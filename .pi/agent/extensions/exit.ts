import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function exitCommand(pi: ExtensionAPI): void {
  pi.registerCommand("exit", {
    description: "Exit Pi cleanly",
    handler: async (_args, ctx) => {
      ctx.shutdown();
    },
  });
}
