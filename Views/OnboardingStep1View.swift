import SwiftUI

struct OnboardingStep1View: View {
    @State private var showNext = false
    @State private var showLogin = false
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 220, height: 220)
                Image(systemName: "book.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            Text("Record Your Dreams")
                .font(.title)
                .fontWeight(.bold)
            Text("Easily record each dream through text or voice, capturing fleeting dream details")
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
                    Capsule().fill(Color.blue).frame(width: 24, height: 8)
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                    Capsule().fill(Color.gray.opacity(0.3)).frame(width: 8, height: 8)
                }
                Spacer()
                Button("Next") { showNext = true }
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 32)
        }
        .fullScreenCover(isPresented: $showNext) {
            OnboardingStep2View()
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
} 