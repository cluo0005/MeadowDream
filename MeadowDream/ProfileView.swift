//
//  ProfileView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showingOnboarding = false
    
    // Privacy settings state variables
    @State private var allowDataCollection = true
    @State private var keepDreamContentPrivate = true
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                        
                        // Privacy Section
                        privacySection
                        
                        // Data Management Section
                        dataManagementSection
                        
                        // About Section
                        aboutSection
                        
                        Spacer(minLength: 20)
                        
                        // Logout Button
                        logoutButton
                        
                        // Bottom padding to avoid floating navigation bar
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                    .padding(.bottom, 20) // Additional bottom padding
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationBarHidden(true)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView()
        }
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
                Text("Appearance")
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
    
    // MARK: - Privacy Section
    private var privacySection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Privacy")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Data Collection
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Data Collection")
                            .font(.body)
                        Spacer()
                        Toggle("", isOn: $allowDataCollection)
                    }
                    Text("Allow anonymous usage data collection")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Dream Content Privacy
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Dream Content Privacy")
                            .font(.body)
                        Spacer()
                        Toggle("", isOn: $keepDreamContentPrivate)
                    }
                    Text("Keep dream content private to your account")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Privacy Policy
                HStack {
                    Image(systemName: "shield.fill")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.red)
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Privacy Policy")
                            .font(.body)
                        Text("Read our privacy policy")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .contentShape(Rectangle())
                .onTapGesture {
                    // Privacy policy action - not implemented
                    print("Privacy Policy tapped")
                }
            }
        }
    }
    
    // MARK: - Data Management Section
    private var dataManagementSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Data Management")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Export Dream Data
                HStack {
                    Image(systemName: "arrow.down.circle.fill")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.orange)
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Export Dream Data")
                            .font(.body)
                        Text("Download all your dream records")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .contentShape(Rectangle())
                .onTapGesture {
                    // Export data action - not implemented
                    print("Export Dream Data tapped")
                }
                
                // Delete Account
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.gray)
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Delete Account")
                            .font(.body)
                            .foregroundColor(.red)
                        Text("Permanently delete your account and data")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .contentShape(Rectangle())
                .onTapGesture {
                    // Delete account action - not implemented
                    print("Delete Account tapped")
                }
            }
        }
    }
    
    // MARK: - About Section
    private var aboutSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("About")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.gray)
                        .cornerRadius(6)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Version")
                            .font(.body)
                        Text("Meadow Dream v1.2.0 • Powered by Firebase")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
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