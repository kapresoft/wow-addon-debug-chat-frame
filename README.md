# DebugChatFrame: A Developer's Tool for WoW Addon Development

[Releases](https://github.com/kapresoft/wow-addon-debug-chat-frame/releases) | [Milestones](https://github.com/kapresoft/wow-addon-debug-chat-frame/milestones) | [Known Issues](https://github.com/kapresoft/wow-addon-debug-chat-frame/issues) | [Curse Forge](https://legacy.curseforge.com/wow/addons/actionbarplus/files)

DebugChatFrame is a highly efficient library addon specifically designed to facilitate World of Warcraft addon developers by providing a dedicated and temporary chat frame for debugging. This tool is load-on-demand, ensuring minimal resource usage until it's explicitly needed.

## Features

- **Load on Demand**: Optimizes performance by loading the library only when required.
- **Easy Initialization**: Seamlessly integrate the debug chat frame into your addon environment at your convenience, ensuring it's available exactly when you need it without cluttering your workspace.
- **Temporary Chat Frame**: The debug chat frame does not persist unnecessarily, keeping your development environment clean and your game interface uncluttered.
- **Simple Logging Interface**: Use the straightforward method `chatFrame:log('hello', 'there')` to begin logging messages to the console. This method supports multiple arguments, allowing comprehensive messages to be logged efficiently.

## Usage

To start using *DebugChatFrame*, simply initialize it within your addon and call the `log` method whenever you need to output debug information. This frame helps keep your regular game chat clean and your debug statements organized.

### Add to Your Addon Toc

Adding the following to your addon's toc file will automatically load DebugChatFrame.

```
## OptionalDeps: DebugChatFrame
```

### Or Programmatically Load the AddOn

With this option you don't need to add the `## OptionalDeps: DebugChatFrame` in the AddOn's toc file. You certainly can try to enable the addon and load it if it exists since the addon is LoadOnDemand.

```lua
EnableAddOn('DebugChatFrame', UnitName('player'))
LoadAddOn('DebugChatFrame')
```

## Ideal For

This tool is ideal for addon developers looking for a simple, effective way to manage debug outputs without interfering with the standard gameplay experience. Whether you're developing a new addon or maintaining an existing one, DebugChatFrame provides a crucial service in managing debug information.

## Donations

As a software engineer, I am passionate about this project and have dedicated a significant amount of time and effort to creating a high-quality product. If you enjoy using this World of Warcraft add-on, please consider supporting me through a donation via Paypal&trade; or the Bitcoin Address provided below. Your support is greatly appreciated. Thank you in advance for your generosity.

**Bitcoin Address**

[https://www.blockchain.com/btc/address/3QQVAwJGkKHMM2oq6CLVWYgfx83TFVwp39](https://www.blockchain.com/btc/address/3QQVAwJGkKHMM2oq6CLVWYgfx83TFVwp39)

&nbsp;

![pixel-line-500px](https://user-images.githubusercontent.com/1599306/209889477-315aa4bb-1e92-4e5f-b684-7d5296427ada.png)

## My Other Addons

- [ActionbarPlus](https://www.curseforge.com/wow/addons/actionbarplus)
- [ActionbarPlus-M6](https://legacy.curseforge.com/wow/addons/actionbarplus-m6)
- [AddonSuite](https://www.curseforge.com/wow/addons/addon-suite)
- [Saved Dungeons & Raids](https://www.curseforge.com/wow/addons/saved-dungeons-raids)
- [Dev Suite](https://www.curseforge.com/wow/addons/devsuite)
- [Addon Template](https://www.curseforge.com/wow/addons/addon-template)
