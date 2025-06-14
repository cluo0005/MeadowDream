import SwiftUI

struct TagLibraryView: View {
    var body: some View {
        NavigationView {
            List {
                Text("System Tag: Flying")
                Text("Custom Tag: Adventure")
            }
            .navigationTitle("Tag Library")
        }
    }
} 