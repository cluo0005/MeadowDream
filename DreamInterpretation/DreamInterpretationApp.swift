//
//  DreamInterpretationApp.swift
//  DreamInterpretation


import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct DreamInterpretationApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var firestoreManager = FirestoreManager()
    @StateObject private var aiService = AIService()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                HomeScreen()
                    .environmentObject(authManager)
                    .environmentObject(firestoreManager)
                    .environmentObject(aiService)
                    .onChange(of: authManager.isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            firestoreManager.refreshForCurrentUser()
                        }
                    }
            } else {
                LoginScreen()
                    .environmentObject(authManager)
            }
        }
    }
}

// Firebase-powered authentication manager
class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        // Listen for authentication state changes
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isLoggedIn = user != nil
            }
        }
    }
    
    deinit {
        if let authListener = authListener {
            Auth.auth().removeStateDidChangeListener(authListener)
        }
    }
    
    // Sign in with email and password
    func signIn(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isLoggedIn = true
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Create new user account
    func signUp(email: String, password: String) async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            await MainActor.run {
                self.currentUser = result.user
                self.isLoggedIn = true
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
            isLoggedIn = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // For backward compatibility
    func login() {
        // This method is kept for compatibility but shouldn't be used
        // Use signIn(email:password:) instead
    }
    
    func logout() {
        signOut()
    }
}
