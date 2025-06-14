import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                // App Logo/Title
                VStack(spacing: 10) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.indigo)
                    Text("Meadow Dream")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Dream Recording & AI Interpretation")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                // Login Form
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    if !authManager.errorMessage.isEmpty {
                        Text(authManager.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    Button(action: {
                        Task {
                            if isSignUpMode {
                                await authManager.signUp(email: email, password: password)
                            } else {
                                await authManager.signIn(email: email, password: password)
                            }
                        }
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(isSignUpMode ? "Create Account" : "Sign In")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.indigo : Color.gray)
                        .cornerRadius(10)
                    }
                    .disabled(!isFormValid || authManager.isLoading)
                    Button(action: {
                        isSignUpMode.toggle()
                        authManager.errorMessage = ""
                    }) {
                        Text(isSignUpMode ? "Already have an account? Sign In" : "Don't have an account? Create Account")
                            .font(.subheadline)
                            .foregroundColor(.indigo)
                    }
                }
                Spacer()
                Text("By signing in, you agree to our Terms of Service")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 30)
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && password.count >= 6
    }
} 