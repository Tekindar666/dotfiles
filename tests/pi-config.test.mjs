import assert from "node:assert/strict";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import test from "node:test";

const root = fileURLToPath(new URL("../.pi/", import.meta.url));

function files(directory) {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = join(directory, entry.name);
    return entry.isDirectory() ? files(path) : [path];
  });
}

test("personal Pi configuration is valid JSON and has no former-company resources", () => {
  for (const path of files(root)) {
    const content = readFileSync(path, "utf8");
    if (path.endsWith(".json")) JSON.parse(content);
    assert.doesNotMatch(content, /inkitt|galatea|vulcan|qa-buddy|sync-staging-flash|flash-db-migrate/i, path);
  }
  for (const path of [
    "agent/learner-profile.json", "agent/auth.json", "agent/trust.json",
    "agent/skills/qa-buddy", "agent/skills/flash-db-migrate", "agent/skills/sync-staging-flash",
  ]) {
    assert.equal(existsSync(join(root, path)), false, path);
  }
  const settings = JSON.parse(readFileSync(join(root, "agent/settings.json"), "utf8"));
  assert.deepEqual(settings.npmCommand, ["pnpm"]);
  const mcp = JSON.parse(readFileSync(join(root, "agent/mcp.json"), "utf8"));
  assert.ok(mcp.mcpServers.playwright);
});
