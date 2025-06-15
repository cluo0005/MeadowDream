//
//  ProfileView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Profile Content
                VStack(spacing: 24) {
                    // Profile Avatar
                    profileAvatarView
                    
                    // User Info
                    userInfoView
                    
                    // Settings Section
                    settingsSection
                    
                    Spacer()
                    
                    // Logout Button
                    logoutButton
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 40)
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .onAppear {
            // Apply dark mode globally when this view appears
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
        .onChange(of: isDarkMode) { newValue in
            // Apply dark mode globally when toggle changes
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.overrideUserInterfaceStyle = newValue ? .dark : .light
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Spacer()
            
            Text("Profile")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Profile Avatar View
    private var profileAvatarView: some View {
        VStack(spacing: 16) {
            if let user = authManager.user {
                Text(user.initials)
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 120)
                    .background(Color(red: 0.357, green: 0.498, blue: 1.0))
                    .clipShape(Circle())
                    .shadow(color: Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.3), radius: 10, x: 0, y: 4)
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 120))
                    .foregroundColor(Color(.secondarySystemFill))
            }
        }
    }
    
    // MARK: - User Info View
    private var userInfoView: some View {
        VStack(spacing: 12) {
            if let user = authManager.user {
                Text(user.displayName ?? "Dream Explorer")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(user.email ?? "")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                
                // Member since
                Text("Member since \(formatDate(user.metadata.creationDate))")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            } else {
                Text("Not signed in")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Settings Section
    private var settingsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Settings")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Dark Mode Toggle
                HStack {
                    Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                        .font(.system(size: 16))
                        .foregroundColor(isDarkMode ? .blue : .orange)
                        .frame(width: 24)
                    
                    Text("Dark Mode")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isDarkMode)
                        .labelsHidden()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        Button(action: {
            authManager.signOut()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16, weight: .medium))
                
                Text("Sign Out")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.bottom, 40)
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthenticationManager())
} 