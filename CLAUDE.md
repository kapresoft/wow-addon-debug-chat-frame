# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DebugChatFrame is a World of Warcraft **library addon** (`LoadOnDemand: 1`) that opens a chat tab for debug/trace output. Other addons (ABP, DevSuite, etc.) call the global `DebugChatFrame:New(opt, callbackFn)` and log through the returned chat frame. It supports every WoW client (Retail, Classic Era, TBC, Wrath, Cata, Mists).

## Build & Release

See "Build & Release (WoW addons)" in the global `~/.claude/CLAUDE.md`.

## Architecture

### Load order

A single `DebugChatFrame.toc` lists every client in its `## Interface:` line and loads `ThirdParty\ThirdParty.xml`, then lists each of the addon's own files directly. Add new files to the TOC.

Third-party libs (LibStub, AceLocale, CallbackHandler, AceEvent, LibPrettyPrint, Kapresoft-LibUtil modules) are pulled into the gitignored `ThirdParty/Libs/` by `w-sync-libs` from `dev/setup.yml`, and loaded by `ThirdParty/ThirdParty.xml`. Release packaging uses `pkgmeta.yaml`, which has its own `ignore` list; keep the two in sync when adding a lib.

### Namespace & flavor detection

`Libs/Core.lua` defines the namespace (`Namespace_DebugChatFrame`, from `addon, ns = ...`) and mixes in `Kapresoft-GameVersionMixin-2-0`. Branch on client differences with its checks (`ns:IsClassicEra()`, `ns:IsTBC()`, `ns:IsWOTLKOrLater()`, ...).

### Key files (`Libs/`)

| File | Role |
|---|---|
| `Core.lua` | Namespace, `prefix`/`log` helpers, debug flags |
| `DebugChatFrameMixin.lua` | Global `DebugChatFrame` API and the `ChatLogFrameMixin` applied to each created chat frame |
| `Annotations/` | EmmyLua type annotations |
| `Lib/Locales/` | AceLocale strings |
| `Fonts/` | Bundled fonts for the chat frame |
| `Assets/` | Textures (logo, etc.) |
| `Developer/` | Dev-only setup and utilities, excluded from packaging (see below) |

### Dev-only code

Wrap dev-only code in the packager's do-not-package tokens: `#@do-not-package@` / `#@end-do-not-package@` around TOC entries (see the `Libs\Developer` lines in `DebugChatFrame.toc`), `--@do-not-package@` in Lua, **not** ABP's `--@debug@`. The packager strips these blocks in release builds, and `pkgmeta.yaml` also ignores `Libs/Developer`.

## Key conventions

- **Mixin-based OOP:** composition via `Mixin()`/`CreateFromMixins()`, not inheritance chains. Keep mixins focused on a single concern.
- **Testing in game:** `/fstack` to inspect frames, `/dump` to inspect values.
- **SavedVariables:** `DEBUG_CHAT_FRAME_PLUS_DB`, `DEBUG_CHAT_FRAME_LOG_LEVEL` (see `DebugChatFrame.toc`).
- **This is a consumed library:** avoid breaking changes to the public API (`DebugChatFrame`, and the chat frame methods in `Libs/Annotations/`) without checking downstream consumers.

## Code style

Formatting is enforced by `stylua.toml`: 100-column width, 2-space indent, Unix line endings, prefer single quotes, keep parens on function calls, collapse simple statements onto one line. Match this on touched lines; don't reformat whole files as a side effect of an unrelated change.
