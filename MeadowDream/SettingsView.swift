//
//  SettingsView.swift
//  MeadowDream

import SwiftUI

struct SettingsView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingOnboarding = false
    
    var body: some View {
        NavigationView {
            List {
                Section("Appearance") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                Section("Help & Support") {
                    Button("Show Onboarding Again") {
                        showingOnboarding = true
                    }
                    .foregroundColor(.blue)
                    
                    Button("Reset Onboarding (Debug)") {
                        hasSeenOnboarding = false
                    }
                    .foregroundColor(.orange)
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
        }
    }
}

#Preview {
    SettingsView()
} 