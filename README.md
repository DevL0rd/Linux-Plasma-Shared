# Linux-Plasma-Shared

Shared QML components and JavaScript helpers used by the `Linux-*` Plasma 6
widgets (System Monitor, Process Monitor, Router Monitor, Log Monitor, Plasma
Portals, Android Daemon). Kept here once so the copies don't drift across repos.

## Contents

| File | Type | What it is |
|------|------|------------|
| `FileWatcher.qml` | QML `Item` | Fires `changed()` when a watched file is rewritten — event-driven (watches the parent dir, so it survives an atomic `os.replace`). No polling. |
| `Sparkline.qml`   | QML | Inline sparkline chart. |
| `Gauge.qml`       | QML | Circular value gauge (uses `Format.js`). |
| `Format.js`       | JS  | Number / byte / time formatting helpers. |
| `Ring.js`         | JS  | Fixed-size ring buffer for rolling history. |

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
