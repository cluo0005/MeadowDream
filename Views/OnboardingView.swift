import SwiftUI

struct OnboardingView: View {
    @State private var page = 0
    var body: some View {
        TabView(selection: $page) {
            VStack {
                Text("Record Your Dreams")
                    .font(.title)
                Text("Easily record each dream through text or voice, capturing fleeting dream details.")
                    .padding()
            }.tag(0)
            VStack {
                Text("AI Dream Interpretation")
                    .font(.title)
                Text("Get multi-dimensional insights into your dreams through advanced AI technology.")
                    .padding()
            }.tag(1)
            VStack {
                Text("Positive Guidance")
                    .font(.title)
                Text("Get personalized positive psychological guidance.")
                    .padding()
            }.tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
    }
} 