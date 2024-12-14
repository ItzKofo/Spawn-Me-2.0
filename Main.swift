// Main.swift 
// by @d7c3g6

import SwiftUI

// Main entry point of the application
@main
struct Main: App {
    var body: some Scene {
        WindowGroup {
            // Set SplashScreenView as the initial view
            SplashScreenView()
        }
    }
}

// Splash screen view structure
struct SplashScreenView: View {
    // State variable to control when to show the main content
    @State private var isActive = false

    var body: some View {
        VStack {
            if isActive {
                // When isActive is true, show the main content
                // This assumes you have a ContentView.swift file with the main app content
                ContentView()
            } else {
                // When isActive is false, show the splash screen
                // Load the image named "image" from the asset catalog
                Image(uiImage: UIImage(named: "image") ?? UIImage())
                    .resizable() // Make the image resizable
                    .scaledToFit() // Scale the image to fit the screen while maintaining aspect ratio
                    .edgesIgnoringSafeArea(.all) // Extend the image to cover the entire screen, including safe areas
            }
        }
        .onAppear {
            // This code runs when the view appears
            // Create a 2.5 second delay before showing the main content
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // Use animation when changing isActive to true
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}
