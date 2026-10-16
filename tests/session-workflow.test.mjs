import assert from "node:assert/strict";
import { execFile, execFileSync } from "node:child_process";
import { mkdtemp, rm } from "node:fs/promises";
import { createRequire } from "node:module";
import { tmpdir } from "node:os";
import { join } from "node:path";
import test from "node:test";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";

const exec = promisify(execFile);
const globalRoot = execFileSync("npm", ["root", "-g"], { encoding: "utf8" }).trim();
const requirePi = createRequire(join(globalRoot, "@earendil-works/pi-coding-agent/package.json"));
const { createJiti } = requirePi("jiti");
const extension = await createJiti(import.meta.url).import(
  fileURLToPath(new URL("../.pi/agent/extensions/session-workflow.ts", import.meta.url)),
  { default: true },
);

function session(t, { pane = "%7", execute, name } = {}) {
  const events = new Map();
  const calls = [];
  const notices = [];
  const output = [];
  const ctx = { cwd: "/repo/project", ui: { notify: (...args) => notices.push(args) } };
  const pi = {
    on: (event, callback) => events.set(event, callback),
    getSessionName: () => name,
    exec: async (command, args, options) => {
      calls.push({ command, args, options });
      if (execute) return execute(command, args, options);
      return { stdout: "", stderr: "", code: 0 };
    },
  };
  const previous = process.env.TMUX_PANE;
  if (pane === null) delete process.env.TMUX_PANE;
  else process.env.TMUX_PANE = pane;
  try { extension(pi); } finally {
    if (previous === undefined) delete process.env.TMUX_PANE;
    else process.env.TMUX_PANE = previous;
  }
  const write = process.stdout.write;
  t.mock.method(process.stdout, "write", function (chunk, ...args) {
    if (typeof chunk === "string" && (chunk.startsWith("\x1b]777;") || chunk.startsWith("\x1bPtmux;"))) {
      output.push(chunk);
      return true;
    }
    return write.call(this, chunk, ...args);
  });
  return {
    calls, events, notices, output, ctx,
    rename: (value) => { name = value; },
    emit: (event, data = {}) => events.get(event)?.(data, ctx),
  };
}

function framing(t, inside) {
  const previous = process.env.TMUX;
  if (inside) process.env.TMUX = "/test/socket,1,0";
  else delete process.env.TMUX;
  t.after(() => {
    if (previous === undefined) delete process.env.TMUX;
    else process.env.TMUX = previous;
  });
  return (body) => inside
    ? `\x1bPtmux;\x1b\x1b]777;notify;Pi;${body}\x07\x1b\\`
    : `\x1b]777;notify;Pi;${body}\x07`;
}

for (const inside of [false, true]) {
  const mode = inside ? "inside tmux" : "outside tmux";
  test(`completion follows the current session name (${mode})`, async (t) => {
    const notification = framing(t, inside);
    const f = session(t, { pane: inside ? "%7" : null, name: "Original name" });
    await f.emit("session_start");
    await f.emit("agent_start");
    await f.emit("agent_end");
    assert.deepEqual(f.output, [], "only settled runs notify");
    await f.emit("agent_settled");
    f.rename("Renamed session");
    await f.emit("session_info_changed", { name: "Renamed session" });
    await f.emit("agent_settled");
    assert.deepEqual(f.output, [
      notification("Pi has finished working on Original name"),
      notification("Pi has finished working on Renamed session"),
    ]);
    if (!inside) assert.deepEqual(f.calls, []);
  });

  for (const name of [undefined, ""]) {
    test(`unnamed completion falls back to cwd for ${JSON.stringify(name)} (${mode})`, async (t) => {
      const notification = framing(t, inside);
      const f = session(t, { name });
      f.ctx.cwd = "/repo/project;\nname";
      await f.emit("agent_settled");
      assert.deepEqual(f.output, [notification("Pi has finished working on project: name")]);
      assert.deepEqual(f.calls, [], "completion never writes tmux status");
    });
  }

  test(`session names cannot escape notification framing (${mode})`, async (t) => {
    const notification = framing(t, inside);
    const f = session(t, { name: "Review;name\x00\t\n\r\x1b\x07\x1f\x7fnext; café 🚀" });
    await f.emit("agent_settled");
    assert.deepEqual(f.output, [notification("Pi has finished working on Review:name next: café 🚀")]);
  });
}

for (const failure of ["exit", "timeout", "throw"]) {
  test(`tmux ${failure} warns once without blocking notifications`, async (t) => {
    const f = session(t, { name: "Task", execute: async () => {
      if (failure === "throw") throw new Error("spawn tmux ENOENT");
      return { code: 1, killed: failure === "timeout", stdout: "", stderr: "fixture failure" };
    } });
    await f.emit("session_start");
    await f.emit("session_info_changed", { name: "Renamed" });
    await f.emit("agent_settled");
    assert.equal(f.notices.length, 1);
    assert.match(f.notices[0][0], /Check tmux, then \/reload/);
    if (failure === "timeout") assert.match(f.notices[0][0], /timed out/);
    assert.equal(f.output.length, 1);
  });
}

test("real tmux: naming works while lifecycle events leave styles, hooks and Workmux status untouched", async (t) => {
  const root = await mkdtemp(join(tmpdir(), "pi-session-workflow-"));
  const socket = join(root, "socket");
  const tmux = async (...args) => (await exec("tmux", ["-S", socket, ...args])).stdout.trimEnd();
  t.after(async () => {
    try { await tmux("kill-server"); } finally { await rm(root, { recursive: true, force: true }); }
  });
  const pane = await tmux("-f", "/dev/null", "new-session", "-d", "-P", "-F", "#{pane_id}", "-s", "test", "sleep 300");
  await tmux("set-option", "-w", "-t", pane, "window-status-style", "fg=red,bg=black");
  await tmux("set-option", "-w", "-t", pane, "window-status-current-style", "fg=white,bg=blue");
  await tmux("set-option", "-w", "-t", pane, "@workmux_status", "working");
  await tmux("set-hook", "-g", "session-window-changed[3]", "set-option -g @existing-hook yes");
  const hooks = await tmux("show-hooks", "-g");
  const f = session(t, { pane, name: "Pi task", execute: async (command, args, options) => {
    const result = await exec(command, ["-S", socket, ...args], options);
    return { ...result, code: 0 };
  } });
  assert.deepEqual(f.calls, [], "factory starts no external work");
  await f.emit("session_start");
  assert.equal(await tmux("display-message", "-p", "-t", pane, "#{window_name}"), "Pi task");
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "automatic-rename"), "off");
  const before = f.calls.length;
  for (const event of ["agent_start", "agent_end", "agent_settled", "session_shutdown"]) await f.emit(event);
  assert.equal(f.calls.length, before, "agent lifecycle never touches tmux");
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "window-status-style"), "fg=red,bg=black");
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "window-status-current-style"), "fg=white,bg=blue");
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "@workmux_status"), "working");
  assert.equal(await tmux("show-hooks", "-g"), hooks);
  assert.doesNotMatch(await tmux("show-options", "-w", "-t", pane), /@pi-workflow-/);
  assert.doesNotMatch(await tmux("show-options", "-p", "-t", pane), /@pi-workflow-/);
  await f.emit("session_info_changed", { name: "Renamed" });
  assert.equal(await tmux("display-message", "-p", "-t", pane, "#{window_name}"), "Renamed");
  await f.emit("session_info_changed", { name: undefined });
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "@pi-session-name"), "");
  assert.equal(await tmux("show-options", "-wqv", "-t", pane, "automatic-rename"), "on");
  assert.deepEqual(f.notices, []);
  assert.ok(f.calls.every(({ command, options }) => command === "tmux" && options.timeout === 1500));
});
