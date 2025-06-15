//
//  MeadowDreamApp.swift
//  MeadowDream

import SwiftUI
import FirebaseCore

@main
struct MeadowDreamApp: App {
    @StateObject private var authManager = AuthenticationManager()
    @State private var showingSplash = true
    @State private var showingOnboarding = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
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
                } else if !hasSeenOnboarding {
                    OnboardingView()
                        .transition(.opacity)
                        .onDisappear {
                            hasSeenOnboarding = true
                        }
                } else {
                    ContentView()
                        .environmentObject(authManager)
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .onAppear {
                // 重置onboarding状态，确保每次启动都显示完整流程
                hasSeenOnboarding = false
                
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
