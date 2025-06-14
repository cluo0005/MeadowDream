//
//  MainTabView.swift
//  MeadowDream

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0 // Default to Home tab (dream list)
    @State private var showingAddDream = false
    
    init() {
        // Ensure we always start on the home tab (dream list)
        _selectedTab = State(initialValue: 0)
    }
    
    var body: some View {
        ZStack {
            // Main Content - Direct view switching instead of TabView
            Group {
                switch selectedTab {
                case 0:
                    // Home Tab - Dream List Screen
                    DreamHomeView()
                case 2:
                    // Stats Tab - Statistics Screen
                    StatsView()
                case 3:
                    // Settings Tab
                    ProfileView()
                default:
                    // Home Tab as fallback
                    DreamHomeView()
                }
            }
            
            // Custom Bottom Navigation Bar
            VStack {
                Spacer()
                customTabBar
            }
        }
        .sheet(isPresented: $showingAddDream) {
            AddDreamView()
        }
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            // Home - Navigate to Dream List
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            // Record
            TabBarButton(
                icon: "plus",
                title: "Record",
                isSelected: false
            ) {
                showingAddDream = true
            }
            
            // Stats - Navigate to Statistics Screen
            TabBarButton(
                icon: "chart.pie.fill",
                title: "Stats",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            // Settings
            TabBarButton(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 34) // Dynamic safe area
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView()
} 