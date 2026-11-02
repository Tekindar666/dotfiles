import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const TMUX_SESSION_NAME_OPTION = "@pi-session-name";


/** Mirrors session names without styling tmux tabs. */
export default function sessionWorkflow(pi: ExtensionAPI): void {
  const pane = process.env.TMUX_PANE;
  let warned = false;

  async function tmux(args: string[]): Promise<string> {
    const result = await pi.exec("tmux", args, { timeout: 1500 });
    if (result.killed || result.code !== 0) {
      throw new Error(result.killed ? "tmux timed out" : result.stderr.trim() || `tmux exited ${result.code}`);
    }
    return result.stdout.replace(/\n$/, "");
  }

  async function syncTmuxWindow(name: string | undefined, ctx: ExtensionContext): Promise<void> {
    if (!pane) return;
    try {
      if (!name) {
        const marker = await tmux(["show-options", "-wqv", "-t", pane, TMUX_SESSION_NAME_OPTION]);
        if (!marker) return;
        await tmux(["set-window-option", "-u", "-t", pane, TMUX_SESSION_NAME_OPTION]);
        await tmux(["set-window-option", "-t", pane, "automatic-rename", "on"]);
        return;
      }
      await tmux(["rename-window", "-t", pane, name]);
      await tmux(["set-window-option", "-t", pane, TMUX_SESSION_NAME_OPTION, name]);
    } catch (error) {
      if (warned) return;
      warned = true;
      ctx.ui.notify(`Pi tmux naming: ${error instanceof Error ? error.message : String(error)}. Check tmux, then /reload.`, "warning");
    }
  }

  pi.on("session_start", async (_event, ctx) => {
    await syncTmuxWindow(pi.getSessionName(), ctx);
  });

  pi.on("session_info_changed", async (event, ctx) => {
    await syncTmuxWindow(event.name, ctx);
  });
}
