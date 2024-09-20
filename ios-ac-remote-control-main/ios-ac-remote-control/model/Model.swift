import Foundation

class Model: Codable {
    // Singleton instance
    static let shared = Model()
    
    // CodingKeys enumeration to specify the encoding and decoding keys
       private enum CodingKeys: String, CodingKey {
           case _devices
           case _rooms
           case _presets
       }

    // Private fields
    
    private var _devices: [Device] = []
    private var _rooms: [Room] = []
    private var _presets: [Preset] = []
    
    
    private var _memoryManager: MemoryManager = MemoryManager()

    // Private initializer to enforce singleton pattern
    private init() {
        // Initialize properties from MemoryManager
        if let model = _memoryManager.load() {
            self._devices = model._devices
            self._rooms = model._rooms
            self._presets = model._presets
        } else {
            self._presets = [ Preset(name: "home"),
            Preset(name: "away"),
            Preset(name: "current")]
        }
    }
    
    deinit {
        _memoryManager.save(model: self)
    }

    // Getter and setter for deviceManagers
    
    // Getter and setter for devices
    var devices: [Device] {
        get {
            return _devices
        }
        set {
            _devices = newValue
        }
    }

    // Getter and setter for rooms
    var rooms: [Room] {
        get {
            return _rooms
        }
        set {
            _rooms = newValue
        }
    }

    // Getter and setter for scenes
    var presets: [Preset] {
        get {
            return _presets
        }
        set {
            _presets = newValue
        }
    }
    
    
        static func save() {
            // Use MemoryManager to save the model
            Model.shared._memoryManager.save(model: Model.shared)
        }
    

    
}
