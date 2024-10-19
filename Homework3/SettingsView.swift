import SwiftUI

struct SettingsView: View {
    @State private var apiUrl: String = UserSettings.shared.apiUrl
    @State private var showImages: Bool = UserSettings.shared.showImages
    
    var body: some View {
        Form {
            Section(header: Text("API Settings")) {
                TextField("API URL", text: $apiUrl)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: apiUrl) { newValue in
                            // Save the new API URL in UserDefaults
                        UserSettings.shared.apiUrl = newValue
                    }
            }
            
            Section(header: Text("Display Settings")) {
                Toggle("Show Images", isOn: $showImages)
                    .onChange(of: showImages) { newValue in
                            // Save the show images setting in UserDefaults
                        UserSettings.shared.showImages = newValue
                    }
            }
        }
        .navigationTitle("Settings")
    }
}
