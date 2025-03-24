# Spawn-Me-2.0
Custom notification creator for iOS 

## Overview
Spawn Me 2.0 is an iOS application designed to help you create and manage **custom notifications** for popular apps like **Revolut** and **Instagram**. The app focuses on streamlining your notification process by offering fully customizable templates and features such as delayed notifications. Future updates will expand support to additional applications and include advanced features.

---

## Features

### 1. Create and Manage Notification Templates
- **Custom Templates**: Easily create tailored notification templates for your needs.
- **Edit/Delete Options**: Seamlessly manage your templates for quick adjustments.
- **Multi-App Support**: Currently supports **Revolut** (finance) and **Instagram** (social media), with more apps planned in future updates.

### 2. Delayed Notifications
- **Precise Timing**: Add delays to your notifications, ensuring they trigger exactly when you need them.
- **Workflow Optimization**: Ideal for scheduled reminders or tasks without overwhelming you with instant notifications.

### 3. Future Expandability
- **Additional App Integrations**: More apps will be supported in future releases, including messaging and productivity tools.
- **Flexible Notification Options**: Planned features include advanced scheduling, custom sounds, and recurring notifications.

---

## How to Add Custom App Icon - Tutorial

### 1. Prepare Icon Images
Prepare your icon in the following sizes:
- 60x60 pixels (@1x)
- 120x120 pixels (@2x)
- 180x180 pixels (@3x)

Format: PNG
Recommendation: Icon should have a transparent background and be visually consistent with other icons.

### 2. Add Files to Project
1. Open your Xcode project
2. Drag prepared files into the Resources folder
3. In the "Add files to project" dialog, ensure:
   - "Copy items if needed" is checked
   - Correct target is selected
   - "Add to targets" is selected

### 3. Modify Info.plist
Add new icon to `CFBundleAlternateIcons` section:
<key>CFBundleIcons</key>
<dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <!-- Existing icons -->
        <key>NEW_ICON_NAME</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>NEW_ICON_NAME</string>
            </array>
            <key>UIPrerenderedIcon</key>
            <false/>
        </dict>
    </dict>
</dict>

### 4. Update SettingsView.swift
Add new icon to `iconOptions` list:


let iconOptions = [
    AppIcon(name: "ig", displayName: "Instagram"),
    AppIcon(name: "rev", displayName: "Revolut"),
    AppIcon(name: "NEW_ICON_NAME", displayName: "DISPLAY_NAME") // New icon
]

### Example: Adding Twitter Icon
Let's add a Twitter icon:

1. Prepare files:
   - twitter.png (60x60)
   - twitter@2x.png (120x120)
   - twitter@3x.png (180x180)

2. In Info.plist add:


<key>twitter</key>
<dict>
    <key>CFBundleIconFiles</key>
    <array>
        <string>twitter</string>
    </array>
    <key>UIPrerenderedIcon</key>
    <false/>
</dict>

4. In SettingsView.swift add:

   
let iconOptions = [
    AppIcon(name: "ig", displayName: "Instagram"),
    AppIcon(name: "rev", displayName: "Revolut"),
    AppIcon(name: "twitter", displayName: "Twitter")
]

### Important Notes:
- File names must exactly match the names in code
- All icon sizes must be exact
- Clean build folder (Product > Clean Build Folder) and rebuild after adding new icon
- Test icon changes on real device, not just simulator

### Testing:
1. Build and run the app
2. Go to Settings view
3. Select your new icon from the list
4. Verify the icon changes successfully

For any issues, check:
- File names and paths
- Info.plist configuration
- Image sizes and formats

#
### Important Notes:
- Clean and rebuild project after changes
- Test on both simulator and real device
- Ensure new images are properly added to asset catalog
- Consider different screen sizes when changing images

---

## Requirements
- iOS 15.0 or later
- iPhone compatible
- Xcode 13.0 or later for development

---

## Installation
1. Clone this repository
2. Build and run the project

---

## License
This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact
For any questions or suggestions, please open an issue in this repository.
