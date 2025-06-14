import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Account Settings")
                Text("Notification Settings")
                Text("Lucid Dream Guide")
            }
            .navigationTitle("Settings")
        }
    }
} 