// SettingsView.swift
// Created by @d7c3g6

import SwiftUI 

// MARK: - App Icon Model
/// Model representing an alternative app icon
struct AppIcon: Identifiable {
    let id = UUID()                // Unique identifier for each icon
    let name: String               // Internal name used for icon switching
    let displayName: String        // User-friendly name shown in UI
    let image: String              // Image asset name
}

// MARK: - Settings View
/// View for managing app settings and icon customization
struct SettingsView: View {
    // MARK: - Properties
    
    // Persistent storage for current app icon
    @AppStorage("appIcon") private var currentIcon: String = "AppIcon"
    
    // State variables for UI management
    @State private var selectedIcon: String = "AppIcon"
    @State private var showingConfirmation = false
    @State private var iconToChange: AppIcon?
    
    // Available app icons
    let appIcons: [AppIcon] = [
        AppIcon(name: "AppIcon", displayName: "Default App Icon", image: "AppIcon"),
        AppIcon(name: "ig", displayName: "Instagram", image: "ig"),
        AppIcon(name: "rev", displayName: "Revolut", image: "rev"),
        AppIcon(name: "settings", displayName: "Settings", image: "settings")
    ]
    
    // MARK: - Initialization
    /// Sets up initial UI appearance and loads saved icon selection
    init() {
        UITableView.appearance().backgroundColor = .black
        _selectedIcon = State(initialValue: UserDefaults.standard.string(forKey: "appIcon") ?? "AppIcon")
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                // MARK: - Icon Selection Section
                Section(header: Text("Icon Settings")
                    .foregroundColor(.white)) {
                    ForEach(appIcons) { icon in
                        VStack(spacing: 16) {
                            HStack {
                                // Icon preview image
                                if let iconImage = UIImage(named: icon.image) {
                                    Image(uiImage: iconImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(12)
                                }
                                
                                // Icon information
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(icon.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(icon.name == "AppIcon" ? "Default Icon" : "Alternative Icon")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.leading, 10)
                                
                                Spacer()
                                
                                // Selection indicator
                                if icon.name == selectedIcon {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .imageScale(.large)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color.black)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            iconToChange = icon
                            showingConfirmation = true
                        }
                    }
                }
                
                // MARK: - About Section
                Section(header: Text("About")
                    .foregroundColor(.white)) {
                    // Developer information
                    HStack {
                        Text("Coded by")
                            .foregroundColor(.white)
                        Spacer()
                        Text("@d7c3g6")
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(Color.black)
                    
                    // Version information
                    HStack {
                        Text("Build Version")
                            .foregroundColor(.white)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(Color.black)
                    
                    // Build type information
                    HStack {
                        Text("Build Type")
                            .foregroundColor(.white)
                        Spacer()
                        Text("Private")
                            .foregroundColor(.gray)
                    }
                    .listRowBackground(Color.black)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.black)
        }
        .preferredColorScheme(.dark)
        // MARK: - Confirmation Alert
        .alert(isPresented: $showingConfirmation) {
            Alert(
                title: Text("Change App Icon"),
                message: Text("Do you want to change the app icon to \(iconToChange?.displayName ?? "")?"),
                primaryButton: .default(Text("Yes")) {
                    if let icon = iconToChange {
                        setAppIcon(to: icon.name)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    // MARK: - Helper Methods
    /// Changes the app icon to the selected alternative icon
    /// - Parameter iconName: The name of the icon to switch to
    private func setAppIcon(to iconName: String) {
        selectedIcon = iconName
        
        UIApplication.shared.setAlternateIconName(iconName == "AppIcon" ? nil : iconName) { error in
            if let error = error {
                print("Error setting alternate icon \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.selectedIcon = self.currentIcon
                }
            } else {
                DispatchQueue.main.async {
                    self.currentIcon = iconName
                }
            }
        }
    }
}