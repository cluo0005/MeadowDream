//
//  SplashView.swift
//  MeadowDream

import SwiftUI

struct SplashView: View {
    @State private var loadingDots: [Bool] = [false, false, false]
    @State private var stars: [StarData] = []
    
    var body: some View {
        ZStack {
            // Gradient Background (matching HTML gradient)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.357, green: 0.498, blue: 1.0),
                    Color(red: 0.655, green: 0.545, blue: 0.980)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Stars Container
            ForEach(stars.indices, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: stars[index].size, height: stars[index].size)
                    .position(x: stars[index].x, y: stars[index].y)
                    .opacity(stars[index].opacity)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                            .delay(stars[index].delay),
                        value: stars[index].opacity
                    )
            }
            
            // Main Content Container
            VStack(spacing: 0) {
                Spacer()
                
                // Logo Container (120x120 like HTML)
                ZStack {
                    // White background with shadow
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.black.opacity(0.1), radius: 25, x: 0, y: 10)
                    
                    // Moon icon (60px like HTML)
                    Image(systemName: "moon.fill")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0)) // Theme primary color
                }
                
                // Title (24px spacing from logo like HTML)
                Text("Meadow Dream")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 24)
                
                // Tagline (8px spacing from title like HTML)
                Text("Record dreams, explore your mind, receive positive guidance")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 280) // Max width like HTML
                    .padding(.top, 8)
                
                // Loading Dots (40px spacing from tagline like HTML)
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .opacity(loadingDots[index] ? 1.0 : 0.6)
                            .scaleEffect(loadingDots[index] ? 1.2 : 1.0)
                            .animation(
                                Animation.easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.3),
                                value: loadingDots[index]
                            )
                    }
                }
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            setupStars()
            startLoadingAnimation()
        }
    }
    
    private func setupStars() {
        // Create 50 stars like HTML
        stars = (0...49).map { _ in
            StarData(
                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                y: CGFloat.random(in: 0...UIScreen.main.bounds.height),
                size: CGFloat.random(in: 1...3), // Random size between 1-3 points like HTML
                opacity: 0,
                delay: Double.random(in: 0...4)
            )
        }
        
        // Start star animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for index in stars.indices {
                stars[index].opacity = 0.8
            }
        }
    }
    
    private func startLoadingAnimation() {
        // Start loading dots animation
        for index in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.3) {
                loadingDots[index] = true
            }
        }
    }
}

struct StarData {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    var opacity: Double
    let delay: Double
}

#Preview {
    SplashView()
} 