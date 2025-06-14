//
//  LoginView.swift
//  MeadowDream

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showSignUp: Bool = false
    @State private var showForgotPassword: Bool = false
    @State private var showAlert: Bool = false
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
                            // Logo Section
                            logoSectionView
                                .padding(.top, 40)
                                .padding(.bottom, 40)
                            
                            // Form Section
                            formSectionView
                                .padding(.horizontal, 20)
                            
                            // Divider
                            dividerView
                                .padding(.horizontal, 20)
                                .padding(.vertical, 30)
                            
                            // Social Login
                            socialLoginView
                                .padding(.horizontal, 20)
                            
                            // Sign Up Section
                            signUpSectionView
                                .padding(.horizontal, 20)
                                .padding(.top, 40)
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
        .sheet(isPresented: $showSignUp) {
            SignUpView()
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(authManager.errorMessage)
        }
        .alert("Password Reset", isPresented: $showForgotPassword) {
            TextField("Email", text: $email)
            Button("Send Reset Email") {
                Task {
                    await authManager.resetPassword(email: email)
                    showAlert = !authManager.errorMessage.isEmpty
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Enter your email address to receive a password reset link.")
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
    
    // MARK: - Logo Section View
    private var logoSectionView: some View {
        VStack(spacing: 16) {
            // Logo
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .frame(width: 80, height: 80)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                Image(systemName: "moon.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.357, green: 0.498, blue: 1.0),
                                Color(red: 0.655, green: 0.545, blue: 0.980)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            // App Name
            Text("Meadow Dream")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.primary)
                .tracking(-0.5)
        }
    }
    
    // MARK: - Form Section View
    private var formSectionView: some View {
        VStack(spacing: 16) {
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
                
                SecureField("••••••••", text: $password)
                    .font(.system(size: 16))
                    .padding(16)
                    .background(Color(.secondarySystemFill))
                    .cornerRadius(12)
                
                HStack {
                    Spacer()
                    Button(action: {
                        showForgotPassword = true
                    }) {
                        Text("Forgot password?")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                    }
                }
                .padding(.top, 8)
            }
            
            // Login Button
            Button(action: {
                loginAction()
            }) {
                HStack {
                    if authManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(authManager.isLoading ? "Signing In..." : "Login")
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
    
    // MARK: - Divider View
    private var dividerView: some View {
        HStack {
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
            
            Text("Or login with")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
            
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 1)
        }
    }
    
    // MARK: - Social Login View
    private var socialLoginView: some View {
        HStack(spacing: 16) {
            // Apple Login Button
            Button(action: {
                print("Apple login tapped")
            }) {
                Image(systemName: "apple.logo")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(width: 50, height: 50)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
            }
            
            // Google Login Button
            Button(action: {
                print("Google login tapped")
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
    
    // MARK: - Sign Up Section View
    private var signUpSectionView: some View {
        HStack {
            Text("Don't have an account?")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Button(action: {
                showSignUp = true
            }) {
                Text("Sign up now")
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
    private func loginAction() {
        // Simple validation
        guard !email.isEmpty && !password.isEmpty else {
            authManager.errorMessage = "Please fill in all fields"
            showAlert = true
            return
        }
        
        Task {
            await authManager.signIn(email: email, password: password)
            if !authManager.errorMessage.isEmpty {
                showAlert = true
            }
        }
    }
}

#Preview {
    LoginView()
} 