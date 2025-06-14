import SwiftUI

struct DreamListView: View {
    var body: some View {
        NavigationView {
            List {
                Text("Dream 1")
                Text("Dream 2")
            }
            .navigationTitle("Dreams")
        }
    }
} 