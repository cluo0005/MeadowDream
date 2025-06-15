//
//  ContentView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: authManager.isAuthenticated)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                // Refresh data when app becomes active
                NotificationCenter.default.post(name: .appDidBecomeActive, object: nil)
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        MainTabView()
    }
}

struct DreamHomeView: View {
    @State private var showingProfile = false
    @State private var dreams: [Dream] = []
    @EnvironmentObject var authManager: AuthenticationManager
    @StateObject private var userSession = UserSessionManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with title and profile
                    headerView
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    
                    // Dreams List
                    ScrollView {
                        if sortedDreams.isEmpty {
                            // Empty State
                            VStack(spacing: 24) {
                                Spacer()
                                
                                VStack(spacing: 16) {
                                    // Book Icon
                                    Image(systemName: "book")
                                        .font(.system(size: 48))
                                        .foregroundColor(.secondary.opacity(0.6))
                                    
                                    // Title
                                    Text("No dreams recorded yet")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    // Description
                                    Text("Start your journey of self-discovery by recording your first dream.\nDreams can provide insights into your subconscious mind.")
                                        .font(.system(size: 16))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(2)
                                        .padding(.horizontal, 40)
                                    
                                    // Record Button
                                    Text("Tap the Record button in the bottom navigation to get started")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color(.secondarySystemFill))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(sortedDreams) { dream in
                                    NavigationLink(destination: 
                                        DreamDetailView(dream: dream)
                                    ) {
                                        DreamCardView(dream: dream)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 120) // Space for bottom navigation
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingProfile) {
                ProfileView()
            }
            .onAppear {
                print("🔄 DreamHomeView appeared - loading dreams")
                loadDreams()
            }
            .onReceive(userSession.$currentUserID) { userID in
                print("🔄 User session changed: \(userID ?? "nil")")
                if userID != nil {
                    loadDreams()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .dreamWasUpdated)) { _ in
                print("🔄 Dream was updated notification - refreshing dreams")
                loadDreams()
            }
            .refreshable {
                print("🔄 Pull to refresh triggered")
                loadDreams()
            }
        }
    }
    
    private func loadDreams() {
        print("🚀 Starting loadDreams function")
        
        // Check if user session is available
        guard let currentUserID = userSession.currentUserID else {
            print("❌ No current user ID available")
            print("   - UserSession state: \(userSession)")
            print("   - Auth state: \(authManager.isAuthenticated)")
            
            // Try to refresh user session if authenticated but no userID
            if authManager.isAuthenticated {
                print("🔄 User is authenticated but no userID - refreshing session")
                userSession.refreshCurrentUser()
                
                // Retry after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if let retryUserID = userSession.currentUserID {
                        print("✅ Retry successful with userID: \(retryUserID)")
                        loadDreams()
                    } else {
                        print("❌ Retry failed - still no userID")
                    }
                }
            }
            return
        }
        
        print("✅ Loading dreams for user: \(currentUserID)")
        
        // Fetch dreams from local storage
        let localDreams = LocalDataManager.shared.fetchDreams(forUserID: currentUserID)
        print("📚 Found \(localDreams.count) dreams in local storage")
        
        // Log some details about the dreams
        for (index, dream) in localDreams.enumerated() {
            print("   Dream \(index + 1): \(dream.title) - \(dream.isInterpreted ? "Interpreted" : "Uninterpreted")")
        }
        
        // Convert to Dream objects
        let convertedDreams = localDreams.map { localDream in
            Dream(from: localDream)
        }
        
        // Update the dreams array on main thread smoothly
        DispatchQueue.main.async {
            print("🔄 Updating dreams array on main thread...")
            print("   - Previous dreams count: \(self.dreams.count)")
            print("   - New dreams count: \(convertedDreams.count)")
            
            // Check if there are actual changes to avoid unnecessary updates
            let currentDreamIds = Set(self.dreams.map { $0.id })
            let newDreamIds = Set(convertedDreams.map { $0.id })
            
            if currentDreamIds != newDreamIds || self.dreams.count != convertedDreams.count {
                // Only update if there are actual changes
                withAnimation(.easeInOut(duration: 0.3)) {
                    self.dreams = convertedDreams
                }
                print("✅ Updated dreams array with \(self.dreams.count) dreams")
            } else {
                print("📝 No changes detected, skipping update")
            }
            
            print("🎯 Sorted dreams count: \(self.sortedDreams.count)")
            
            // Log the actual dreams in the array
            for (index, dream) in self.dreams.enumerated() {
                print("   UI Dream \(index + 1): \(dream.title) - Date: \(dream.date)")
            }
        }
    }
    
    // MARK: - Computed Properties
    private var sortedDreams: [Dream] {
        return dreams.sorted { $0.dateCreated > $1.dateCreated }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Dreams")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                if let user = authManager.user {
                    Text("Welcome back, \(user.displayName ?? "Dreamer")")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Profile Button
            Button(action: {
                showingProfile = true
            }) {
                if let user = authManager.user {
                    Text(user.initials)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color(red: 0.357, green: 0.498, blue: 1.0))
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(.secondarySystemFill))
                        .clipShape(Circle())
                }
            }
        }
    }
    

}

enum EmotionType: String, Codable {
    case positive, negative, neutral
    
    init(rawValue: String) {
        switch rawValue.lowercased() {
        case "positive":
            self = .positive
        case "negative":
            self = .negative
        default:
            self = .neutral
        }
    }
    
    var color: Color {
        switch self {
        case .positive: return .green
        case .negative: return .red
        case .neutral: return .gray
        }
    }
    
    var icon: String {
        switch self {
        case .positive: return "leaf.fill"
        case .negative: return "exclamationmark.triangle.fill"
        case .neutral: return "circle.fill"
        }
    }
    
    var text: String {
        switch self {
        case .positive: return "Positive"
        case .negative: return "Negative"
        case .neutral: return "Neutral"
        }
    }
}

// MARK: - Dream Card View (Redesigned to match reference)
struct DreamCardView: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date and time in top left
            HStack {
                Text(formatDateTime(dream.date))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // Dream title
            Text(dream.title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Dream content preview
            Text(dream.preview)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Tags and status row
            HStack {
                // Content tags (blue pills)
                ForEach(dream.tags.prefix(2), id: \.self) { tag in
                    Text(tag)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.15))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Emotion tag
                HStack(spacing: 4) {
                    Image(systemName: dream.emotion.icon)
                        .font(.system(size: 10))
                    Text(getEmotionDisplayName(dream.emotion))
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(dream.emotion.color)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private func formatDateTime(_ dateString: String) -> String {
        // Convert the date string to a format without time like "July 15, 2023"
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMM d, yyyy"
            return outputFormatter.string(from: date)
        }
        
        return dateString // Fallback without time
    }
    
    private func getEmotionDisplayName(_ emotion: EmotionType) -> String {
        switch emotion {
        case .positive: return "Forest"
        case .negative: return "Lost"
        case .neutral: return "Neutral"
        }
    }
}

// MARK: - Tab Bar Item
struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: isSelected ? 22 : 20, weight: .medium))
                    .foregroundColor(isSelected ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                
                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DreamRow: View {
    let dream: Dream
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dream.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(dream.preview)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            HStack {
                ForEach(dream.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                Text(dream.emotion.text)
                    .font(.caption)
                    .padding(4)
                    .background(dream.emotion.color.opacity(0.2))
                    .cornerRadius(4)
            }
        }
        .padding(.vertical, 8)
    }
}

extension Notification.Name {
    static let appDidBecomeActive = Notification.Name("appDidBecomeActive")
    static let dreamWasUpdated = Notification.Name("dreamWasUpdated")
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
}
