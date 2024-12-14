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
            VStack {
                // Displaying templates
                if !templates.isEmpty {
                    List {
                        ForEach(templates) { template in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(template.title)
                                        .font(.headline)
                                    Text(template.content)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(8) // Add padding for better visual alignment
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6)) // Add a background card style
                            )
                            .onTapGesture {
                                // On template selection, update text fields
                                customTitle = template.title
                                customContent = template.content
                                selectedTemplate = template
                            }
                        }
                        .onDelete(perform: deleteTemplate)
                    }
                    .listStyle(InsetGroupedListStyle())
                } else {
                    Text("No templates available.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .bold()
                }

                // Button to create a new template
                Button(action: {
                    if !customTitle.isEmpty || !customContent.isEmpty {
                        showSaveTemplateAlert = true
                    } else {
                        showNewTemplateModal = true
                    }
                }) {
                    Text("Create New Template")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(
                            gradient: Gradient(colors: [.green, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .cornerRadius(10)
                        .shadow(radius: 4) // Add a shadow for depth
                        .padding(.horizontal)
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

                // Text fields
                VStack(alignment: .leading, spacing: 12) {
                    TextField("Notification Title", text: $customTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)

                    TextField("Notification Content", text: $customContent)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
                .padding()

                // Slider for delay
                VStack {
                    Text("Delay: \(Int(delay)) seconds")
                        .font(.headline)
                    Slider(value: $delay, in: 1...60, step: 1)
                        .accentColor(.blue) // Customize slider color
                }
                .padding()

                // Button to send notification
                Button(action: {
                    scheduleNotification(title: customTitle, body: customContent, delay: delay)
                }) {
                    Text("Send Notification")
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
            }
            .navigationTitle("SpawnMe! 2.0")
            .navigationBarItems(
                leading: Button(action: {
                    showSettings = true
                }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                        .foregroundColor(.blue) // Customize color for gear icon
                },
                trailing: EditButton()
            )
            .sheet(isPresented: $showSettings) {
                SettingsView() // Reference to existing settings view
            }
            .onAppear {
                loadTemplates()
            }
        }
    }

    // Function to schedule notification
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

    // Function to delete a template
    func deleteTemplate(at offsets: IndexSet) {
        templates.remove(atOffsets: offsets)

        // Save templates back to UserDefaults
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Error saving templates: \(error.localizedDescription)")
        }
    }

    // Function to save the current template
    func saveCurrentTemplate() {
        let newTemplate = NotificationTemplate(id: (templates.last?.id ?? 0) + 1, title: customTitle, content: customContent)
        templates.append(newTemplate)

        // Save templates to UserDefaults
        do {
            let data = try JSONEncoder().encode(templates)
            UserDefaults.standard.set(data, forKey: templatesKey)
        } catch {
            print("Error saving templates: \(error.localizedDescription)")
        }
    }

    // Load saved templates from UserDefaults
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

// View for creating new templates
struct NewTemplateView: View {
    @Binding var templates: [NotificationTemplate]
    @Environment(\.presentationMode) var presentationMode

    @State private var title: String = ""
    @State private var content: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Content", text: $content)
            }
            .navigationTitle("New Template")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let newTemplate = NotificationTemplate(id: (templates.last?.id ?? 0) + 1, title: title, content: content)
                    templates.append(newTemplate)

                    // Save templates to UserDefaults
                    do {
                        let data = try JSONEncoder().encode(templates)
                        UserDefaults.standard.set(data, forKey: "SavedTemplates")
                    } catch {
                        print("Error saving templates: \(error.localizedDescription)")
                    }

                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}