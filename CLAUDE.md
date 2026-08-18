# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DebugChatFrame is a World of Warcraft **library addon** (`LoadOnDemand: 1`) that provides a dedicated chat-frame-style window for debug/trace output, plus a `DebugChatFrameMixin` other addons (ABP, DevSuite, etc.) embed to log through. It supports all WoW versions (Retail, Classic, TBC, Wrath, Cata, Mists) via per-flavor TOCs.

## Build & Release

### Pull external library dependencies

```shell
w-sync-libs
# Output goes to .release/
```

### Deployment to local WoW installs

#### One-time deploy
```shell
w-deployer-default
```

#### Continuous Deploy (watch mode)

```shell
w-deployer-watch
```

### Release process
1. Create pull requests
2. Create tag to publish--an automated github action will push any tag created
3. Verify CurseForge build is green, then publish the GitHub draft release

There are no automated tests. Validation is done in-game.

## Architecture

### Multiple TOCs, one addon folder

Unlike ABP/DevSuite's single combined TOC, this repo ships **one TOC per flavor** (`DebugChatFrame-Vanilla.toc`, `-TBC.toc`, `-Wrath.toc`, `-Cata.toc`, `-Mists.toc`) plus a combined multi-`## Interface:` `DebugChatFrame.toc` for Retail/newer clients. All of them load the same `ThirdParty\ThirdParty.xml` then `Libs\<Flavor>.lua` then `Libs\_Core.xml` -- when changing load order or adding a new file, update `_Core.xml` once (shared across flavors) rather than duplicating includes per TOC.

### Namespace & flavor detection

`Libs/Core.lua` defines the namespace object (`Namespace_DebugChatFrame`, `addon, ns = ...`). Each flavor's own file (`Libs/Retail.lua`, `Libs/Wrath.lua`, etc.) sets `ns.gameVersion` to a version string (e.g. `'retail'`) -- this is DebugChatFrame's flavor-compat mechanism, simpler than ABP's per-version feature-flag files in `ActionbarPlus-Core/Libs/Flavor/`. Check `ns.gameVersion` when branching on API differences across clients.

### Key files (`Libs/`)

| File | Role |
|---|---|
| `Core.lua` | Namespace definition, addon metadata helpers (`prefix`, `pformat`) |
| `DebugChatFrameMixin.lua` | The mixin other addons embed to get a debug chat frame + logging |
| `Retail.lua` / `Wrath.lua` / `Cata.lua` / `TBC.lua` / `Vanilla.lua` / `Mists.lua` | Per-flavor `ns.gameVersion` setters |
| `Annotations/` | EmmyLua type annotations |
| `Fonts/` | Bundled fonts for the chat frame |
| `Assets/` | Textures (logo, etc.) |
| `Developer/` | Dev-only setup/utilities -- excluded from packaging (see below) |

### Dev-only code

Wrap dev-only Lua/XML with `--@do-not-package@` / `--@end-do-not-package@` tokens (see `Libs/_Core.xml`'s `Developer\_DeveloperSetup.xml`/`_Developer.xml` includes) -- **not** ABP's `--@debug@` convention. The BigWigsMods packager strips these blocks in release builds; `Libs/Developer` is also explicitly excluded via `pkgmeta.yaml`'s `ignore` list.

## Key conventions

- **Mixin-based OOP** -- composition via `Mixin()`/`CreateFromMixins()`, not inheritance chains. Keep mixins focused on a single concern.
- **No unit test framework** -- test in-game. Use `/fstack` to inspect frames, `/dump` to inspect values.
- **EmmyLua annotations** -- the codebase uses EmmyLua (`---@param`, `---@return`, `---@class`) for IDE type checking. Maintain these on public APIs.
- **SavedVariables**: `DEBUG_CHAT_FRAME_PLUS_DB`, `DEBUG_CHAT_FRAME_LOG_LEVEL` -- see any of the flavor TOCs.
- **This is a consumed library** -- other addons (ABP, DevSuite) embed `DebugChatFrameMixin` or depend on this addon via `OptionalDeps`/`RequiredDeps`. Avoid breaking changes to the mixin's public API without checking downstream consumers.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.