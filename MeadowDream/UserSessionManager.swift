import Foundation
import FirebaseAuth

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    
    @Published var currentUserID: String?
    
    private init() {
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUserID = user?.uid
        }
    }
    
    var isUserLoggedIn: Bool {
        return currentUserID != nil
    }
    
    func refreshCurrentUser() {
        print("🔄 Refreshing current user session")
        if let user = Auth.auth().currentUser {
            print("✅ Found Firebase user: \(user.uid)")
            currentUserID = user.uid
        } else {
            print("❌ No Firebase user found")
            currentUserID = nil
        }
    }
} 