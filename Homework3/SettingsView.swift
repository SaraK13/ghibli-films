import SwiftUI

struct SettingsView: View {
    @State private var apiUrl: String = UserSettings.shared.apiUrl
    @State private var showImages: Bool = UserSettings.shared.showImages
    
    var body: some View {
        Form {
            Section(header: Text("API Settings")) {
                TextField("API URL", text: $apiUrl)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: apiUrl) {
                        // Save the new API URL in UserDefaults
                        UserSettings.shared.apiUrl = apiUrl
                    }
            }
            
            Section(header: Text("Display Settings")) {
                Toggle("Show Images", isOn: $showImages)
                    .onChange(of: showImages) {
                        // Save the show images setting in UserDefaults
                        UserSettings.shared.showImages = showImages
                    }
            }
        }
    }
}
