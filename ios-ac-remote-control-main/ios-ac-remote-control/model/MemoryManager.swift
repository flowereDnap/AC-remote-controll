import Foundation

class MemoryManager {
    
    private let modelKey = "com.yourapp.modelKey"

    func load() -> Model? {
        if let data = UserDefaults.standard.data(forKey: modelKey),
           let model = try? JSONDecoder().decode(Model.self, from: data) {
            return model
        } else {
            // Return a new instance of Model if data is not available
            return nil
        }
    }

    func save(model: Model) {
        if let data = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(data, forKey: modelKey)
        }
    }
}
