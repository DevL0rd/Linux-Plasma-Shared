# Plasma-Shared

Shared QML components and JavaScript helpers used by the `Linux-*` Plasma 6
widgets (System Monitor, Process Monitor, Router Monitor, Log Monitor, Plasma
Portals, Android Daemon). Kept here once so the copies don't drift across repos.

## Contents

| File | Type | What it is |
|------|------|------------|
| `FileWatcher.qml` | QML `Item` | Fires `changed()` when a watched file is rewritten — event-driven (watches the parent dir, so it survives an atomic `os.replace`). No polling. |
| `Sparkline.qml`   | QML | Inline sparkline chart, with an optional second series and danger band. |
| `Gauge.qml`       | QML | Circular value gauge (uses `Format.js`). |
| `Format.js`       | JS  | Number / byte / time formatting helpers. |
| `Ring.js`         | JS  | Fixed-size ring buffer for rolling history. |
| `History.js`      | JS  | Named ring buffers for many metrics, plus now / peak / average stats. |
| `Highlight.js`    | JS  | Search matching and match highlighting for labels. |
| `PopStyle.js`     | JS  | Byte formatting, metric colours and heat colours for the popup widgets. |
| `PopupShell.qml`  | QML | Popup frame: header with status dot, search field, tabs and a content area. |
| `PopScroll.qml`   | QML | Scrolling column with animated `scrollTo(item)`. |
| `PopTabs.qml`     | QML | Pill tab bar with a sliding highlight and count badges. |
| `PopCard.qml`     | QML | Card with a title, trailing value, optional fold arrow and a `flash()` highlight. |
| `PopRing.qml`     | QML | Arc gauge with a centred value, label and caption. |
| `PopBar.qml`      | QML | Labelled bar that honours its colour, with an optional peak mark. |
| `PopStat.qml`     | QML | Small label with a large value, unit and trend arrow. |
| `PopMetricTabs.qml` | QML | History graph with metric tabs and now / peak / average. |
| `PopChip.qml`     | QML | Panel button value that adapts to horizontal, vertical and thick panels. |
| `PopConfirm.qml`  | QML | Button that needs a second click, with a draining timer bar. |
| `PopActions.qml`  | QML | Wrapping row of tool buttons from a list of actions. |

`.qml` files are declarative components (an object/visual tree); `.js` files are
plain helper libraries you `import "X.js" as X` and call.

## Usage

Consumed by each widget repo as a git **submodule** at `shared/common`, whose
`install.sh` copies the needed files into each plasmoid's `contents/ui/lib/`
(that synced copy is gitignored — this repo is the single source of truth).

Clone a consumer repo **with submodules**:

```sh
git clone --recurse-submodules <repo-url>
# already cloned without it?
git submodule update --init --recursive
```

Update the shared components everywhere:

```sh
# in this repo: edit + commit + push, then in each consumer:
git submodule update --remote shared/common
```

## License

Released under the [MIT License](LICENSE).
