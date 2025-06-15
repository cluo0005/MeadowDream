//
//  SignUpView.swift
//  MeadowDream

import SwiftUI

struct SignUpView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var agreeToTerms: Bool = false
    @State private var showAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Status Bar
                    statusBarView
                    
                    // Main Content
                    ScrollView {
                        VStack(spacing: 0) {
                            // Header
                            headerView
                                .padding(.horizontal, 20)
                                .padding(.bottom, 30)
                            
                            // Form Section
                            formSectionView
                                .padding(.horizontal, 20)
                            
                            // Divider
                            dividerView
                                .padding(.horizontal, 20)
                                .padding(.vertical, 30)
                            
                            // Social Login
                            socialSignUpView
                                .padding(.horizontal, 20)
                            
                            // Login Section
                            loginSectionView
                                .padding(.horizontal, 20)
                                .padding(.top, 30)
                                .padding(.bottom, 20)
                        }
                    }
                    
                    Spacer()
                }
                
                // Home Indicator
                VStack {
                    Spacer()
                    homeIndicatorView
                        .padding(.bottom, 8)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(authManager.errorMessage)
        }
    }
    
    // MARK: - Status Bar View
    private var statusBarView: some View {
        HStack {
            Text("9:41")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "cellularbars")
                    .font(.system(size: 14, weight: .medium))
                Image(systemName: "wifi")
                    .font(.system(size: 14, weight: .medium))
                Image(systemName: "battery.100")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 5)
        .frame(height: 44)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                    .frame(width: 40, height: 40)
            }
            
            Spacer()
            
            Text("Create Account")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Invisible spacer to balance the back button
            Color.clear
                .frame(width: 40, height: 40)
        }
    }
    
    // MARK: - Form Section View
    private var formSectionView: some View {
        VStack(spacing: 16) {
            // Username Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Username")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                TextField("Enter username", text: $username)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Email Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                TextField("your@email.com", text: $email)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            
            // Password Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                SecureField("At least 8 characters", text: $password)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                    .textContentType(.newPassword)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            // Confirm Password Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                SecureField("Re-enter password", text: $confirmPassword)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                    .textContentType(.newPassword)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
            }
            
            // Terms and Conditions
            termsAndConditionsView
                .padding(.top, 16)
            
            // Sign Up Button
            Button(action: {
                signUpAction()
            }) {
                HStack {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(authManager.isLoading ? "Creating Account..." : "Sign Up")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color(red: 0.357, green: 0.498, blue: 1.0))
                .cornerRadius(12)
                .shadow(color: Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .disabled(authManager.isLoading)
            .padding(.top, 24)
        }
    }
    
    // MARK: - Terms and Conditions View
    private var termsAndConditionsView: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                agreeToTerms.toggle()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(agreeToTerms ? Color(red: 0.357, green: 0.498, blue: 1.0) : Color(.separator), lineWidth: 2)
                        .background(
                            agreeToTerms ? 
                            Color(red: 0.357, green: 0.498, blue: 1.0) : 
                            Color.clear
                        )
                        .frame(width: 22, height: 22)
                    
                    if agreeToTerms {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("I have read and agree to the ")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                + Text("Terms of Service")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                + Text(" and ")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                + Text("Privacy Policy")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
            }
            
            Spacer()
        }
    }
    
    // MARK: - Divider View
    private var dividerView: some View {
        HStack {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
            
            Text("Or sign up with")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
        }
    }
    
    // MARK: - Social Sign Up View
    private var socialSignUpView: some View {
        HStack(spacing: 16) {
            // Apple Sign Up Button
            Button(action: {
                print("Apple signup tapped")
            }) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            }
            
            // Google Sign Up Button
            Button(action: {
                print("Google signup tapped")
            }) {
                Text("G")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.918, green: 0.263, blue: 0.208))
                    .frame(width: 50, height: 50)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Login Section View
    private var loginSectionView: some View {
        HStack {
            Text("Already have an account?")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Button(action: {
                dismiss()
            }) {
                Text("Login now")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
            }
        }
    }
    
    // MARK: - Home Indicator View
    private var homeIndicatorView: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color(.separator))
            .frame(width: 135, height: 5)
    }
    
    // MARK: - Actions
    private func signUpAction() {
        // Validation
        guard !username.isEmpty else {
            authManager.errorMessage = "Please enter a username"
            showAlert = true
            return
        }
        
        guard !email.isEmpty else {
            authManager.errorMessage = "Please enter an email"
            showAlert = true
            return
        }
        
        guard password.count >= 8 else {
            authManager.errorMessage = "Password must be at least 8 characters"
            showAlert = true
            return
        }
        
        guard password == confirmPassword else {
            authManager.errorMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        guard agreeToTerms else {
            authManager.errorMessage = "Please agree to the terms and conditions"
            showAlert = true
            return
        }
        
        Task {
            await authManager.signUp(email: email, password: password, username: username)
            if !authManager.errorMessage.isEmpty {
                showAlert = true
            } else {
                // Success - dismiss the signup view
                dismiss()
            }
        }
    }
}

#Preview {
    SignUpView()
} 