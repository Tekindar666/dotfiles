import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const logo = [
  "██████╗ ██╗",
  "██╔══██╗██║",
  "██████╔╝██║",
  "██╔═══╝ ██║",
  "██║     ██║",
  "╚═╝     ╚═╝",
];

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    if (ctx.mode !== "tui") return;

    ctx.ui.setHeader((_tui, theme) => ({
      render(_width) {
        return [
          "",
          ...logo.map((line) => theme.fg("accent", `  ${line}`)),
          "",
          theme.fg("muted", "  personal coding agent"),
          "",
        ];
      },
      invalidate() {},
    }));
  });
}
