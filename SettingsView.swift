// SettingsView.swift
// by @d7c3g6

import SwiftUI
import UIKit

struct SettingsView: View {
    
    // A list of possible app icon options with internal names and display names
    let iconOptions = [
        AppIcon(name: "ig", displayName: "Instagram"), // Example: An Instagram-themed app icon
        AppIcon(name: "rev", displayName: "Revolut")   // Example: A Revolut-themed app icon
    ]
    
    // Dictionary to map internal icon names to user-friendly display names
    var iconNameMapping: [String: String] {
        Dictionary(uniqueKeysWithValues: iconOptions.map { ($0.name, $0.displayName) })
    }
    
    // The currently selected app icon (nil indicates the default app icon)
    var currentIcon: String? {
        UIApplication.shared.alternateIconName
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // Section: Displaying the currently selected app icon
                    VStack(spacing: 10) {
                        Text("Current Icon")
                            .font(.headline) // Section title
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 15) {
                            // Display the current app icon (if available)
                            if let currentIcon = currentIcon, let image = UIImage(named: currentIcon) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 50) // Set the icon size
                                    .cornerRadius(10) // Add rounded corners
                            } else if let defaultImage = UIImage(named: "AppIcon") {
                                // Display the default app icon (fallback)
                                Image(uiImage: defaultImage)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                            } else {
                                // Placeholder for when no icon image is found
                                Image(systemName: "app")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                            
                            // Display the name of the current icon
                            Text(currentIconDisplayName)
                                .font(.title3)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.secondarySystemBackground)) // Light background for contrast
                        .cornerRadius(10)
                    }
                    
                    Divider() // Separator between sections
                    
                    // Section: Displaying options to choose a new app icon
                    VStack(spacing: 15) {
                        Text("Choose App Icon")
                            .font(.headline) // Section title
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Loop through the icon options and show them as buttons
                        ForEach(iconOptions) { icon in
                            Button(action: {
                                setAppIcon(to: icon.name) // Change app icon when the button is tapped
                            }) {
                                HStack {
                                    // Display the icon image if available
                                    if let image = UIImage(named: icon.name) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(10)
                                    } else {
                                        // Placeholder icon image
                                        Image(systemName: "app")
                                            .font(.title)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    // Display the user-friendly name of the icon
                                    Text(icon.displayName)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                    
                                    Spacer() // Push the next element (checkmark) to the right
                                    
                                    // Show a checkmark next to the currently selected icon
                                    if currentIcon == icon.name || (currentIcon == nil && icon.name == "AppIcon") {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(UIColor.secondarySystemBackground)) // Icon button background
                                .cornerRadius(10)
                            }
                        }
                    }
                    
                    Divider() // Another separator
                    
                    // Section: Resetting to the default app icon
                    VStack(spacing: 15) {
                        Text("Reset Icon")
                            .font(.headline) // Section title
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button(action: {
                            resetAppIconToDefault() // Reset to the default icon when tapped
                        }) {
                            HStack {
                                Text("Reset to Default Icon")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                Spacer()
                                Image(systemName: "arrow.uturn.backward.circle.fill")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red) // Highlight this button in red
                            .cornerRadius(10)
                        }
                    }
                }
                .padding() // Add padding around the entire VStack
            }
            .navigationTitle("Settings") // Set the title of the navigation bar
        }
    }
    
    /// Retrieves the user-friendly name of the currently selected icon or "Default" if it's the default icon.
    var currentIconDisplayName: String {
        if let currentIcon = currentIcon {
            // Use the iconNameMapping dictionary to find the display name
            return iconNameMapping[currentIcon] ?? "Unknown Icon"
        } else {
            return "Default Icon"
        }
    }
    
    /// Changes the app's icon to the specified icon name.
    /// - Parameter iconName: The internal name of the icon to switch to.
    func setAppIcon(to iconName: String) {
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                // Log an error if the icon change fails
                print("Error changing icon to '\(iconName)': \(error.localizedDescription)")
            } else {
                // Log success if the icon change is successful
                print("Icon successfully changed to '\(iconName)'")
            }
        }
    }
    
    /// Resets the app's icon to the default icon.
    func resetAppIconToDefault() {
        UIApplication.shared.setAlternateIconName(nil) { error in
            if let error = error {
                // Log an error if resetting the icon fails
                print("Error resetting to default icon: \(error.localizedDescription)")
            } else {
                // Log success if the icon is reset to default
                print("Icon successfully reset to default")
            }
        }
    }
}

// A model representing app icon information
struct AppIcon: Identifiable {
    let id = UUID()           // Unique identifier for each icon
    let name: String          // Internal name of the icon (used in Info.plist)
    let displayName: String   // User-friendly display name for the icon
}

// Preview provider for SwiftUI previews
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}