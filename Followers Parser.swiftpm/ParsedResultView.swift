import SwiftUI

struct ParsedResultView: View {
    @State var displayText = ""
    let data: Data
    
    private var isParseSuccessful: Bool { displayText != "" }
    
    private var lineCount: Int {
        displayText.split(separator: "\n").count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("\(lineCount) lines")
            
            Group {
                if isParseSuccessful {
                    TextEditor(text: $displayText)
                        .scrollContentBackground(.hidden)
                } else {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Unable to parse JSON data.")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
            
            Button("Copy to clipboard") {
                UIPasteboard.general.string = displayText
            }
            .buttonStyle(.borderedProminent)
            .disabled(!isParseSuccessful)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Parsed Data")
        .onAppear {
            if let list = try? followersList(from: data) {
                displayText = list
            }
        }
    }
}
