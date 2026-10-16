import { copyToClipboard, type ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { buildForkCommand } from "./command.mjs";

export default function copyForkCommand(pi: ExtensionAPI): void {
  pi.registerCommand("cf", {
    description: "Copy a command that forks the current session",
    handler: async (_args, ctx) => {
      const sessionFile = ctx.sessionManager.getSessionFile();
      if (!sessionFile) {
        ctx.ui.notify("Cannot fork an ephemeral session", "error");
        return;
      }

      const command = buildForkCommand(sessionFile);

      try {
        await copyToClipboard(command);
        ctx.ui.notify("Fork command copied", "info");
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        ctx.ui.notify(`Failed to copy fork command: ${message}`, "error");
      }
    },
  });
}
