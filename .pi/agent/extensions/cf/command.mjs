export function quoteShellArg(value) {
  return `'${value.replaceAll("'", `'\\''`)}'`;
}

export function buildForkCommand(sessionFile) {
  return `pi --fork ${quoteShellArg(sessionFile)}`;
}
