//
//  SplashView.swift
//  MeadowDream

import SwiftUI

struct SplashView: View {
    @State private var animateStars = false
    @State private var animateDots = false
    @State private var currentDotCount = 1
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.357, green: 0.498, blue: 1.0),
                    Color(red: 0.655, green: 0.545, blue: 0.980)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated Stars Background
            ForEach(0..<30, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: CGFloat.random(in: 2...4), height: CGFloat.random(in: 2...4))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(animateStars ? 1.0 : 0.3)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 1...3))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateStars
                    )
            }
            
            VStack(spacing: 40) {
                // App Logo/Title
                VStack(spacing: 16) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.3), radius: 10)
                    
                    VStack(spacing: 8) {
                        Text("MeadowDream")
                            .font(.system(size: 32, weight: .light, design: .serif))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.3), radius: 5)
                        
                        Text("Record dreams, explore your mind, receive positive guidance")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .shadow(color: .white.opacity(0.2), radius: 3)
                    }
                }
                
                // Loading Animation
                HStack(spacing: 8) {
                    Text("Loading")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white.opacity(0.9))
                    
                    HStack(spacing: 4) {
                        ForEach(1...3, id: \.self) { index in
                            Circle()
                                .fill(Color.white)
                                .frame(width: 6, height: 6)
                                .opacity(currentDotCount >= index ? 1.0 : 0.3)
                        }
                    }
                }
            }
        }
        .onAppear {
            animateStars = true
            startDotAnimation()
        }
    }
    
    private func startDotAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.3)) {
                currentDotCount = currentDotCount == 3 ? 1 : currentDotCount + 1
            }
        }
    }
}

#Preview {
    SplashView()
} 