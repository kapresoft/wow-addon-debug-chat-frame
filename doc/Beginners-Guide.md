# DebugChatFrame User's Guide

![image](https://github.com/kapresoft/wow-addon-debug-chat-frame/assets/42391379/b615a040-0bf9-46de-8d10-71355ec2d165)

## Overview

DebugChatFrame is a load-on-demand World of Warcraft AddOn Library designed to help developers by providing a dedicated temporary Chat Frame for logging debug messages. This guide will walk you through the installation, usage, and API functions provided by DebugChatFrame to enhance your addon development process.

## Loading the Library

### Declaring as an Optional Dependency

To ensure that "DebugChatFrame" is loaded whenever your addon is running, it is recommended to declare it as an optional dependency in your addon's `.toc` file. This method ensures that "DebugChatFrame" is loaded before your addon if it is present, simplifying dependency management. Add the following line to your `.toc` file to set this up:

```
## OptionalDeps: DebugChatFrame
```

This declaration helps prevent your addon from failing if "DebugChatFrame" is not installed, while also maintaining the ability to use its functionality when available.

### Programmatically Loading the Addon

If you prefer a more dynamic approach, especially useful when your addon might need to enable or disable debugging features based on certain conditions or configurations, you can load "DebugChatFrame" programmatically. This method does not require modifying the `.toc` file and is particularly useful if "DebugChatFrame" is used conditionally or on demand. Use the following Lua script to load the library from within your addon:

```lua
-- Check if DebugChatFrame is installed and attempt to enable it for the current player
if not IsAddOnLoaded('DebugChatFrame') then
    EnableAddOn('DebugChatFrame', UnitName('player'))
    LoadAddOn('DebugChatFrame')
end
```

This script performs a check to see if "DebugChatFrame" is already loaded to avoid unnecessary operations. If it is not loaded, the script tries to enable and then load the addon specifically for the player currently using the addon. This method ensures that "DebugChatFrame" is activated only when needed, optimizing resource use and initialization times.

To enhance the robustness and readability of your function, here's an improved version of your logging code. This version clarifies the decision-making process and ensures that it gracefully handles the presence or absence of the DebugChatFrame, defaulting to the standard console if the frame isn't available:

```lua
function ns.print(...)
    -- Check if the debugFrame is available within the namespace
    if ns.debugFrame then
        -- If debugFrame exists, log the messages to it
        return ns.debugFrame:log(...)
    end
   -- If debugFrame does not exist, fallback to the default print function
   print(...)
end
```

### Explanation:

1. **Checking the Existence**: The function first checks if `ns.debugFrame` exists. This check is crucial as it determines whether the custom logging or the standard logging should be used. Using `if ns.debugFrame then` is a straightforward and clear way to make this determination.

2. **Logging to Debug Frame**: If `ns.debugFrame` is available, the function passes all arguments to the `log` method of the debug frame. This is done using the unpacked arguments represented by `...`, which allows the function to handle any number and combination of arguments seamlessly.

3. **Fallback to Standard Print**: In the absence of a debug frame, the function defaults to the standard `print` function. This ensures that your addon remains functional and that log messages are not lost, even if the debug setup is not active or properly configured.

This approach not only ensures that your addon's logging is resilient but also maintains clear and easy-to-understand code, making maintenance and troubleshooting more straightforward.

## Usage

### Initializing DebugChatFrame

Before you can log any messages, you must create a new debug frame, which is typically done when your addon is loaded. Here's an example of how to initialize DebugChatFrame using a more detailed approach:

```lua
local addon, ns = ...
local module = 'DebugChatFrameExample'

ns.debugFrame = DebugChatFrame:New(opt, function(chatFrame)
   chatFrame:log(module, 'chatFrame:', chatFrame:GetName())
   chatFrame:log(module, 'options:', {1, 2, 3})
   chatFrame:log(module, 'tab-name:', chatFrame:GetTabName())
end);
```

### Breakdown of the Code:

#### Define the Module

`local addon, ns = ...`

This line captures the addon name and its namespace from the environment, which are typically passed when the Lua file is executed by WoW's UI engine.

`local module = 'DebugChatFrameExample'`

This sets a local variable `module` to be used as an identifier in logging messages.

### Create the Debug Frame

`ns.debugFrame = DebugChatFrame:New(opt, function(chatFrame) ... end)`
This function call creates a new debug chat frame.

- `opt`: Represents the options table for configuring the debug frame (not shown in detail here, needs to be defined elsewhere or passed in).
- The second argument is a callback function that initializes the debug frame when it is created.

In your DebugChatFrame initialization code, the callback function serves as a powerful tool for customizing and setting up the chat frame right after its creation. This function provides an opportunity to configure specific properties, log initial settings, or perform any other setup actions required by your addon.

Here's an extended explanation of how the callback function enhances the initialization process:

### Enhancing Initialization with a Callback Function

The callback function in the `DebugChatFrame:New()` method is executed immediately after the debug chat frame is successfully created. This allows for dynamic customization based on current runtime conditions or specific configurations. Here is how it works:

```lua
local addon, ns = ...
local module = 'DebugChatFrameExample'

-- Initialize and customize the debug chat frame
ns.debugFrame = DebugChatFrame:New(opt, function(chatFrame)
    -- Log the creation and properties of the new chat frame
    chatFrame:log(module, 'chatFrame:', chatFrame:GetName())
    chatFrame:log(module, 'options:', {1, 2, 3})
    chatFrame:log(module, 'tab-name:', chatFrame:GetTabName())

    -- Additional customization can be done here
    -- For example, setting the font or text color of the debug messages
    chatFrame:SetFont('Fonts\\FRIZQT__.TTF', 11)
    chatFrame:SetTextColor(1, 0.5, 0)  -- Orange text
end);

-- in a lua module called Developer.lua, this is another log
ns.debugFrame:logp('Developer', 'Loaded...')
```

Here's an example debug chat frame using a fixed-width (monospace) font [_Inconsolata_](https://fonts.google.com/specimen/Inconsolata?classification=Monospace)

![image](https://github.com/kapresoft/wow-addon-debug-chat-frame/assets/1599306/ab87d8e3-4db7-4671-bdd1-e4ea7fafceb5)


#### Detailed Explanation:

1. **Dynamic Configuration:**
   - The callback function is a place to apply configurations that may depend on conditions or settings determined at runtime. For example, setting the text color based on the type of messages you expect to log.

2. **Immediate Feedback:**
   - By logging messages about the chat frame itself (like its name or tab-name), you provide immediate feedback on its creation and setup, which is invaluable during development.

3. **Extended Customization:**
   - Beyond basic logging, the callback allows for extended customization such as adjusting visual aspects. In the example, the `SetFont` and `SetTextColor` methods modify the appearance of the text, making it easier to distinguish debug messages from regular chat.

This setup not only initializes the debug frame but also tailors it to the specific needs of your addon, leveraging the full flexibility of the `DebugChatFrame` library to enhance debugging and development workflows.

This initialization script is ideal for setting up a debug environment where you can track different aspects of your addon's behavior and configuration in real-time. Ensure that `DebugChatFrame` and any necessary configuration options (`opt`) are correctly defined to use this feature effectively.

Here are various ways a developer can utilize an instance of DebugChatFrame to enhance debugging and monitoring in the development of a World of Warcraft addon. The following examples illustrate how this powerful tool can be employed to log different types of messages:

### Standard Logging

For straightforward logging needs, developers can log simple messages using the `log` method of the DebugChatFrame instance. This method is designed to handle quick and basic message outputs to the debug frame. For example:

```lua
f:log('Hello', 'World')
```

In this case, `f` is an instance of DebugChatFrame. The `log` function takes multiple arguments and concatenates them, resulting in the output "Hello World" in the debug chat frame. This method is ideal for simple concatenations or when direct and simple feedback is needed.

### Logging with a Prefix by Lua Module

When working with complex addons that include multiple modules, it's beneficial to prepend log entries with a module identifier to clarify the source of the message. DebugChatFrame supports this through a method like `logp`, which might be designed to automatically format and prepend a module name to the message:

```lua
f:logp(module, 'Loading...')
```

This line would output a string formatted as `{{ Addon::Module }}: Loading...`, assuming the `logp` method formats the `module` variable and message accordingly. This feature is useful for developers who need to maintain clear and organized logs, especially when debugging interactions between multiple components or modules within the addon.

### Global Logging Function

To further simplify logging throughout an addon, a global function `c()` can be defined. This function checks if the `ns.chatFrame` (a namespace-global instance of DebugChatFrame) is available and uses it to log messages. If the debug frame isn't available, it defaults to printing the messages to the standard console:

```lua
--- @vararg any
function c(...)
    if ns.chatFrame then return ns.chatFrame:log(...) end
    print(...)
end
```

This function is highly flexible due to its variadic nature, accepting any number of arguments. The use of `...` allows it to handle multiple arguments seamlessly, making it an ideal choice for general-purpose logging across the addon's codebase:

```lua
c('MainModule::', 'Hello There')
```
The output of this usage would be "MainModule:: Hello There", formatted by the global `c()` function, showing in the dedicated debug chat frame if available, or in the game's default chat otherwise.

## Lua Code for an Example Usage

```lua
--[[-----------------------------------------------------------------------------
DebugChatFrame Usage
-------------------------------------------------------------------------------]]
local addon, ns = ...
local module = 'DebugChatFrameExample'

--[[-----------------------------------------------------------------------------
Type: ChatLogFrame
-------------------------------------------------------------------------------]]
--- @class _ChatLogFrame
--- @field log fun(self:_ChatLogFrame, ...)
--- @field logp fun(self:_ChatLogFrame, name:string, ...)

--[[-----------------------------------------------------------------------------
Type: DebugChatFrameOptions
-------------------------------------------------------------------------------]]
--- @class _DebugChatFrameOptions
local opt = {
    addon = addon,
    chatFrameName = 'dev',
    --- ### See Fonts: [_Fonts.xml](https://github.com/kapresoft/wow-addon-debug-chat-frame/blob/a0d3dca2d410198b9da1c9821e5b97c12f774cfc/Core/Fonts/_Fonts.xml)    font = DCF_ConsoleMonoCondensedSemiBold,
    --- @see Blizzard Interface/FrameXML/Fonts.xml
    --- @type Font
    font = DCF_ConsoleMonoCondensedSemiBold,
    size = 16,
    windowAlpha = 1.0,
    maxLines = 100,
}

--[[-----------------------------------------------------------------------------
Type: DebugChatFrame Interface
-------------------------------------------------------------------------------]]
--- @alias DebugChatFrameCallbackFn fun(chatFrame:_ChatLogFrame) | "function(chatFrame) chatFrame:log('hello') end"
---
--- @class _DebugChatFrame
--- @field New fun(self:_DebugChatFrame, opt:DebugChatFrameOptions, callbackFn:DebugChatFrameCallbackFn) : _ChatLogFrame

--- interface
--- @type _DebugChatFrame
local DebugChatFrame = {}

--[[-----------------------------------------------------------------------------
Main Code
-------------------------------------------------------------------------------]]

local f = DebugChatFrame:New(opt, function(chatFrame)
    chatFrame:log(module, 'chatFrame:', chatFrame:GetName())
    chatFrame:log(module, 'options:', {1, 2, 3})
    chatFrame:log(module, 'tab-name:', chatFrame:GetTabName())
end);
ns.chatFrame = f

-- standard logging
-- output: Hello World
f:log('Hello', 'World')

-- By Lua Module
-- Output: {{ Addon::Module }}: Loading...
f:logp(module, 'Loading...')

-- define a global function c()
--- @vararg any
function c(...)
    if ns.chatFrame then return ns.chatFrame:log(...) end
    print(...)
end

-- Usage
-- Output: MainModule:: Hello There
c('MainModule::', 'Hello There')
```

## Support

For issues, suggestions, or contributions, please file and [issue](/kapresoft/wow-addon-debug-chat-frame/issues/new/choose) to start the discussion.

