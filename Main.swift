import SwiftUI

@main
struct Main: App {
    init() {
        // Inicializace NotificationManager při startu aplikace
        _ = NotificationManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}