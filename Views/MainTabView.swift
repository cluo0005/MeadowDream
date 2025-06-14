import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            DreamListView()
                .tabItem { Label("Dreams", systemImage: "list.bullet") }
            StatsOverviewView()
                .tabItem { Label("Stats", systemImage: "chart.bar") }
            TagLibraryView()
                .tabItem { Label("Tags", systemImage: "tag") }
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
        }
    }
} 