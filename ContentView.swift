// ContentView.swift
// by @d7c3g6

import SwiftUI
import UserNotifications

// Model for notification templates
struct NotificationTemplate: Identifiable, Codable {
    let id: Int
    let title: String
    let content: String
}

struct ContentView: View {
    @State private var templates: [NotificationTemplate] = []
    @State private var selectedTemplate: NotificationTemplate?
    @State private var customTitle: String = ""
    @State private var customContent: String = ""
    @State private var delay: Double = 3.0
    @State private var showSettings: Bool = false
    @State private var showSaveTemplateAlert: Bool = false
    @State private var showNewTemplateModal: Bool = false
    private let templatesKey = "SavedTemplates"

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background for the main screen
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Displaying saved templates
                    if !templates.isEmpty {
                        ScrollView {
                            ForEach(templates) { template in
                                TemplateCardView(template: template)
                                    .onTapGesture {
                                        // Update text fields when selecting a template
                                        customTitle = template.title
                                        customContent = template.content
                                        selectedTemplate = template
                                    }
                                    .contextMenu {
                                        Button(role: .destructive) {
                                            deleteTemplate(id: template.id)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Placeholder for an empty state
                        VStack {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No templates available.")
                                .foregroundColor(.gray)
                                .font(.title3)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }

                    Spacer()

                    // Button to create a new template
                    CustomButton(title: "Create New Template", gradient: Gradient(colors: [Color.green, Color.blue])) {
                        if !customTitle.isEmpty || !customContent.isEmpty {
                            showSaveTemplateAlert = true
                        } else {
                            showNewTemplateModal = true
                        }
                    }
                    .padding(.horizontal)

                    // Text fields for custom notification inputs
                    VStack(alignment: .leading, spacing: 12) {
                        CustomTextField(iconName: "text.cursor", placeholder: "Notification Title", text: $customTitle)
                        CustomTextField(iconName: "doc.text", placeholder: "Notification Content", text: $customContent)
                    }
                    .padding()

                    // Slider for scheduling delay
                    VStack {
                        Text("Delay: \(Int(delay)) seconds")
                            .font(.headline)
                        Slider(value: $delay, in: 1...60, step: 1)
                            .accentColor(.blue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ))
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .padding()

                    // Button to send notification
                    CustomButton(title: "Send Notification", gradient: Gradient(colors: [Color.blue, Color.purple])) {
                        scheduleNotification(title: customTitle, body: customContent, delay: delay)
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("SpawnMe! 2.0")
                .navigationBarItems(
                    leading: Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                    },
                    trailing: EditButton()
                )
                .sheet(isPresented: $showSettings) {
                    SettingsView() // Link to an existing SettingsView file
                }
                .alert(isPresented: $showSaveTemplateAlert) {
                    Alert(
                        title: Text("Save Current Template?"),
                        message: Text("Do you want to save the current title and content as a new template?"),
                        primaryButton: .default(Text("Yes")) {
                            saveCurrentTemplate()
                        },
                        secondaryButton: .cancel(Text("No")) {
                            showNewTemplateModal = true
                        }
                    )
                }
                .sheet(isPresented: $showNewTemplateModal) {
                    NewTemplateView(templates: $templates)
                }
                .onAppear {
                    loadTemplates()
                }
            }
        }
    }

    // Function to schedule a notification
    func scheduleNotification(title: String, body: String, delay: Double) {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled with title: \(title)")
                    }
                }
            } else {
                print("Notification permission not granted.")
            }
        }
    }

    // Function to delete a template by ID
    func deleteTemplate(id: Int) {
        templates.removeAll { $0.id == id }
        saveTemplates()
    }

    // Function to save the current template
    func saveCurrentTemplate() {
        let newTemplate = NotificationTemplate(id: (templates.last?.id ?? 0) + 1, title: customTitle, content: customContent)
        templates.append(newTemplate)
        saveTemplates()
    }

    // Function to save templates to UserDefaults
    func saveTemplates() {
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Error saving templates: \(error.localizedDescription)")
        }
    }

    // Function to load templates from UserDefaults
    func loadTemplates() {
        if let data = UserDefaults.standard.data(forKey: templatesKey) {
            do {
                let decodedTemplates = try JSONDecoder().decode([NotificationTemplate].self, from: data)
                templates = decodedTemplates
            } catch {
                print("Error decoding templates: \(error.localizedDescription)")
            }
        }
    }
}

// Reusable component for template cards
struct TemplateCardView: View {
    var template: NotificationTemplate

    var body: some View {
        VStack(alignment: .leading) {
            Text(template.title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(template.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.3), Color.white]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        )
    }
}

// Reusable component for custom text fields
struct CustomTextField: View {
    var iconName: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .padding(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
    }
}

// Reusable component for custom gradient buttons
struct CustomButton: View {
    var title: String
    var gradient: Gradient
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
}
