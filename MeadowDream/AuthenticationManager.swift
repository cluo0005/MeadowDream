//
//  AuthenticationManager.swift
//  MeadowDream

import Foundation
import FirebaseAuth
import Combine

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        setupAuthStateListener()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Auth State Listener
    private func setupAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
                
                if let user = user {
                    await self?.fetchUserProfile(uid: user.uid)
                }
            }
        }
    }
    
    // MARK: - Sign Up
    func signUp(email: String, password: String, username: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // Update display name
            let changeRequest = result.user.createProfileChangeRequest()
            changeRequest.displayName = username
            try await changeRequest.commitChanges()
            
            // Create user profile in Firestore
            await createUserProfile(uid: result.user.uid, email: email, username: username)
            
        } catch {
            errorMessage = handleAuthError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            errorMessage = handleAuthError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = "Failed to sign out: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Password Reset
    func resetPassword(email: String) async {
        isLoading = true
        errorMessage = ""
        
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            errorMessage = handleAuthError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Local Storage Operations
    private func createUserProfile(uid: String, email: String, username: String) async {
        let userProfile = UserProfile(uid: uid, email: email, username: username)
        LocalDataManager.shared.saveUser(userProfile)
    }
    
    private func fetchUserProfile(uid: String) async {
        if let userProfile = LocalDataManager.shared.fetchUser(byID: uid) {
            print("User profile loaded from local storage")
        } else {
            // Create profile if it doesn't exist
            if let user = Auth.auth().currentUser {
                await createUserProfile(
                    uid: uid,
                    email: user.email ?? "",
                    username: user.displayName ?? "User"
                )
            }
        }
    }
    
    // MARK: - Error Handling
    private func handleAuthError(_ error: Error) -> String {
        if let authError = error as NSError? {
            switch authError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                return "This email is already registered. Please use a different email or try signing in."
            case AuthErrorCode.weakPassword.rawValue:
                return "Password is too weak. Please choose a stronger password."
            case AuthErrorCode.invalidEmail.rawValue:
                return "Please enter a valid email address."
            case AuthErrorCode.userNotFound.rawValue:
                return "No account found with this email. Please check your email or sign up."
            case AuthErrorCode.wrongPassword.rawValue:
                return "Incorrect password. Please try again."
            case AuthErrorCode.userDisabled.rawValue:
                return "This account has been disabled. Please contact support."
            case AuthErrorCode.tooManyRequests.rawValue:
                return "Too many failed attempts. Please try again later."
            case AuthErrorCode.networkError.rawValue:
                return "Network error. Please check your internet connection."
            default:
                return "Authentication failed: \(error.localizedDescription)"
            }
        }
        return error.localizedDescription
    }
}

// MARK: - User Extension
extension User {
    var initials: String {
        let name = displayName ?? email ?? "User"
        let components = name.components(separatedBy: " ")
        let initials = components.compactMap { $0.first }.prefix(2)
        return String(initials).uppercased()
    }
} 