import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Animated star background
            Color(.systemIndigo).ignoresSafeArea()
            ForEach(0..<50) { i in
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: CGFloat.random(in: 1...3), height: CGFloat.random(in: 1...3))
                    .position(x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                              y: CGFloat.random(in: 0...UIScreen.main.bounds.height))
                    .opacity(animate ? 1 : 0.5)
                    .animation(Animation.easeInOut(duration: 2).repeatForever().delay(Double(i) * 0.05), value: animate)
            }
            VStack(spacing: 24) {
                Image(systemName: "moon.stars.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                Text("Meadow Dream")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Dream Recording, AI Interpretation & Positive Guidance")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .onAppear {
            animate = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                isActive = true
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            OnboardingStep1View()
        }
    }
} 