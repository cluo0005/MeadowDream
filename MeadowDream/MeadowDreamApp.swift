//
//  MeadowDreamApp.swift
//  MeadowDream

import SwiftUI
import FirebaseCore

@main
struct MeadowDreamApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @State private var showingSplash = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showingSplash {
                    SplashView()
                        .transition(.opacity)
                } else {
                    ContentView()
                        .environmentObject(authManager)
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .onAppear {
                // Hide splash screen after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showingSplash = false
                    }
                }
            }
        }
    }
}
