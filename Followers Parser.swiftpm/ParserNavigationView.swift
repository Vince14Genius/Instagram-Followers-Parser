import SwiftUI

struct ParserNavigationView: View {
    var body: some View {
        NavigationView {
            ParseTextView()
        }
        .navigationViewStyle(.stack)
    }
}
