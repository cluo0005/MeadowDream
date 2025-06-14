import SwiftUI

struct OnboardingStep3View: View {
    @State private var showLogin = false
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.15))
                    .frame(width: 220, height: 220)
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
            }
            Text("Positive Guidance")
                .font(.title)
                .fontWeight(.bold)
            Text("Receive positive suggestions and guidance based on your dreams, helping you grow and improve your well-being")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
            HStack {
                Button("Skip") { showLogin = true }
                    .foregroundColor(.gray)
                Spacer()
                HStack(spacing: 8) {
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    Capsule().fill(Color.green).frame(width: 24, height: 8)
                }
                Spacer()
                Button("Get Started") { showLogin = true }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
} 