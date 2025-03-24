// ContentView.swift
// Created by @d7c3g6

import SwiftUI
import UserNotifications

// Data model for notification templates
// Identifiable - allows use in ForEach
// Codable - enables JSON encoding/decoding for storage
struct NotificationTemplate: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
}

struct ContentView: View {
    // MARK: - State Properties
    // State variables to manage the UI and data
    @State private var templates: [NotificationTemplate] = [] // Stores all notification templates
    @State private var selectedTemplate: NotificationTemplate? // Currently selected template
    @State private var customTitle: String = "" // User input for notification title
    @State private var customContent: String = "" // User input for notification content
    @State private var delay: Double = 3.0 // Delay time for notifications (in seconds)
    
    // Modal presentation states
    @State private var showSettings: Bool = false
    @State private var showSaveTemplateAlert: Bool = false
    @State private var showNewTemplateModal: Bool = false
    
    // Key for UserDefaults storage
    private let templatesKey = "SavedTemplates"

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Template List Section
                // Shows list of saved templates if available, otherwise displays placeholder text
                if !templates.isEmpty {
                    List {
                        ForEach(templates) { template in
                            // Template card view
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(template.title)
                                        .font(.headline)
                                    Text(template.content)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                            // Load template data when tapped
                            .onTapGesture {
                                customTitle = template.title
                                customContent = template.content
                                selectedTemplate = template
                            }
                        }
                        .onDelete(perform: deleteTemplate)
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    Text("No templates available!")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .bold()
                }

                // MARK: - Create Template Button
                // Button to create new template or save current input as template
                Button(action: {
                    if !customTitle.isEmpty || !customContent.isEmpty {
                        showSaveTemplateAlert = true
                    } else {
                        showNewTemplateModal = true
                    }
                }) {
                    // Button styling
                    Text("Create New Template")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                }
                
                // MARK: - Input Fields Section
                // Text fields for notification content
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Notification Title", text: $customTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)

                    TextField("Notification Text", text: $customContent)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding()

                // MARK: - Delay Control Section
                // Slider to control notification delay
                VStack {
                    Text("Spawn Delay: \(Int(delay)) seconds")
                        .font(.headline)
                    Slider(value: $delay, in: 1...60, step: 1)
                        .accentColor(.blue)
                }
                .padding()

                // MARK: - Notification Buttons
                // Buttons to trigger immediate or delayed notifications
                HStack {
                    // Immediate notification button
                    Button(action: { sendImmediateNotification() }) {
                        Text("Spawn Now!")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                    
                    // Delayed notification button
                    Button(action: { sendDelayedNotification() }) {
                        Text("Spawn with Delay")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .cornerRadius(10)
                            .shadow(radius: 4)
                    }
                }
                .padding(.horizontal)
            }
            // MARK: - Navigation Bar Configuration
            .navigationTitle("SpawnMe! 2.0")
            .navigationBarItems(
                leading: Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                },
                trailing: EditButton()
            )
            .onAppear { loadTemplates() }
        }
    }

    // MARK: - Helper Functions
    
    // Sends immediate notification
    func sendImmediateNotification() {
        NotificationManager.shared.sendImmediateNotification(
            title: customTitle,
            message: customContent
        )
    }
    
    // Sends delayed notification
    func sendDelayedNotification() {
        NotificationManager.shared.sendDelayedNotification(
            title: customTitle,
            message: customContent,
            delay: delay
        )
    }

    // Deletes template and updates storage
    func deleteTemplate(at offsets: IndexSet) {
        templates.remove(atOffsets: offsets)
        saveTemplates()
    }

    // Saves current input as new template
    func saveCurrentTemplate() {
        let newTemplate = NotificationTemplate(
            id: (templates.last?.id ?? 0) + 1,
            title: customTitle,
            content: customContent
        )
        templates.append(newTemplate)
        saveTemplates()
    }

    // Loads saved templates from UserDefaults
    func loadTemplates() {
        if let data = UserDefaults.standard.data(forKey: templatesKey) {
            do {
                templates = try JSONDecoder().decode([NotificationTemplate].self, from: data)
            } catch {
                print("Error decoding templates: \(error.localizedDescription)")
            }
        }
    }
    
    // Saves templates to UserDefaults
    private func saveTemplates() {
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Error saving templates: \(error.localizedDescription)")
        }
    }
}