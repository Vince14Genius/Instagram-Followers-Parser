import SwiftUI

struct ParseTextView: View {
    @State private var jsonText = ""
    @State private var isImportPresented = false
    @State private var isImportErrorAlertPresented = false
    
    @FocusState private var isFocusedOnJSONEditor
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack(alignment: .center) {
                TextEditor(text: $jsonText)
                    .focused($isFocusedOnJSONEditor)
                    .scrollContentBackground(.hidden)
                    .font(.body.monospaced())
                    .padding()
                    .background(Color(.tertiarySystemBackground))
                    .cornerRadius(8)
                if jsonText.isEmpty {
                    VStack(spacing: 16) {
                        Text("Paste JSON text here or import file.")
                        Text("You can download JSON followers data from Instagram's account settings")
                    }
                    .allowsHitTesting(false)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(.tertiaryLabel))
                }
            }
            HStack {
                Button("Clear Text") {
                    jsonText = ""
                    isFocusedOnJSONEditor = false
                }
                .disabled(jsonText.isEmpty)
                NavigationLink("Parse") {
                    ParsedResultView(data: jsonText.data(using: .utf8) ?? Data())
                }
                .buttonStyle(.borderedProminent)
                .disabled(jsonText.isEmpty)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Input JSON")
        .toolbar {
            Button("Import File") {
                isImportPresented = true
                isFocusedOnJSONEditor = false
            }
        }
        .fileImporter(isPresented: $isImportPresented, allowedContentTypes: [.json]) { result in
            do {
                let fileURL = try result.get()
                if fileURL.startAccessingSecurityScopedResource() {
                    let fileText = try String(contentsOf:fileURL) 
                    jsonText = fileText
                }
            } catch {
                isImportErrorAlertPresented = true
            }
        }
        .alert(isPresented: $isImportErrorAlertPresented) {
            Alert(
                title: Text("Import Failed"),
                message: Text("Unable to open file")
            )
        }
    }
}
