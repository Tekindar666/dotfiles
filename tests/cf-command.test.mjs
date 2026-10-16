import assert from "node:assert/strict";
import test from "node:test";

import { buildForkCommand, quoteShellArg } from "../.pi/agent/extensions/cf/command.mjs";

test("quotes shell arguments", () => {
  assert.equal(quoteShellArg("/Users/Ed Tan/project's files"), "'/Users/Ed Tan/project'\\''s files'");
});

test("builds only the fork command without changing directories", () => {
  assert.equal(
    buildForkCommand("/Users/Ed Tan/.pi/sessions/session file.jsonl"),
    "pi --fork '/Users/Ed Tan/.pi/sessions/session file.jsonl'",
  );
});
