import SwiftUI

@main
struct MeadowDreamApp: App {
    @StateObject private var authManager = AuthManager()
    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                SplashView()
                    .environmentObject(authManager)
            }
        }
    }
} 