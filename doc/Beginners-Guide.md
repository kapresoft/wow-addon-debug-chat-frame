# DebugChatFrame User's Guide

![image](https://github.com/kapresoft/wow-addon-debug-chat-frame/assets/42391379/b615a040-0bf9-46de-8d10-71355ec2d165)

## Overview

DebugChatFrame is a load-on-demand World of Warcraft AddOn Library designed to help developers by providing a dedicated temporary Chat Frame for logging debug messages. This guide will walk you through the installation, usage, and API functions provided by DebugChatFrame to enhance your addon development process.

## Installation via CurseForge App

The CurseForge App is a popular method for managing World of Warcraft addons, ensuring that you always have the latest updates and features. Follow these steps to download and install DebugChatFrame through the CurseForge App:

1. **Install the CurseForge App:**
   If you haven’t already installed the CurseForge App, download it from the official CurseForge website. Install the application on your computer following the provided instructions.

2. **Open the CurseForge App:**
   Launch the CurseForge App and select 'World of Warcraft' from the list of supported games.

3. **Navigate to the Addons Section:**
   Once in the World of Warcraft interface, switch to the 'Get More Addons' tab. This is where you can browse and install new addons.

4. **Search for DebugChatFrame:**
   Use the search bar at the top of the CurseForge interface and type "DebugChatFrame." Make sure you spell it correctly to find the addon.

5. **Install the Addon:**
   Click on the DebugChatFrame in the search results, and then press the 'Install' button. The CurseForge App will automatically handle the download and installation process. It will place the DebugChatFrame folder in the correct directory (`_retail_\Interface\AddOns`).

6. **Check for Updates:**
   CurseForge App automatically checks for updates, but you can manually update DebugChatFrame by selecting it in the 'My Addons' tab and clicking 'Update' if an update is available.

7. **Enable the Addon in WoW:**
   Next time you launch World of Warcraft, make sure to enable DebugChatFrame from the AddOns menu in the character select screen. If it's not listed, restart your game to ensure it loads properly.

By following these steps, you should have DebugChatFrame installed and ready to help you with debugging your own addons. Remember to frequently check for updates to keep the library up-to-date with the latest features and bug fixes.


## Manual Installation

1. **Download the Library:** Obtain the latest version of DebugChatFrame from the [official repository or download site].
2. **Install the Library:** Place the DebugChatFrame folder into your World of Warcraft `_retail_\Interface\AddOns` directory.
3. **Load the Library in Your AddOn:** Ensure DebugChatFrame is listed as an optional dependency in your AddOn's `.toc` file:

   ```
   ## OptionalDeps: DebugChatFrame
   ```

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
```

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


## Support

For issues, suggestions, or contributions, please file and [issue](https://github.com/kapresoft/wow-addon-debug-chat-frame/issues/new/choose) to start the discussion.
