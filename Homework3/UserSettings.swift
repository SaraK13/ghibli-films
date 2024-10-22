import Foundation

class UserSettings {
    static let shared = UserSettings() // singleton, which means only one instance is created.
    
    private init() {
        registerDefaults()
    }
    
    let userDefaults = UserDefaults.standard
    
    enum Keys {
        static let apiUrl = "apiUrl"
        static let showImages = "showImages"
    }
    
    // Register default values
    func registerDefaults() {
        userDefaults.register(defaults: [
            Keys.apiUrl: "https://ghibliapi.vercel.app/films", // Default API URL
            Keys.showImages: true // Default to showing images
        ])
    }
    
    // API URL
    var apiUrl: String {
        get {
            return userDefaults.string(forKey: Keys.apiUrl) ?? "https://ghibliapi.vercel.app/films"
        }
        set {
            userDefaults.set(newValue, forKey: Keys.apiUrl)
        }
    }
    
    // Show/Hide Images
    var showImages: Bool {
        get {
            return userDefaults.bool(forKey: Keys.showImages)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.showImages)
        }
    }
}
