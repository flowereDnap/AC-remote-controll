import Foundation

class Device: Codable, Identifiable, ObservableObject {
    
    var id: String {cid}

    private enum CodingKeys: String, CodingKey {
        case properties
        case name
        case cid
        case version
        case manager
    }

    var properties: [String: CodableValue] {
        didSet {
            Model.save()
        }
    }

    var name: String {
        didSet {
            Model.save()
        }
    }

    var cid: String {
        didSet {
            Model.save()
        }
    }

    var version: String {
        didSet {
            Model.save()
        }
    }
    
    weak var room: Room? {
        didSet {
            Model.save()
        }
    }
    
    var manager: DeviceManager? {
        didSet {
            Model.save()
        }
    }

    init(properties: [String: CodableValue] = [:],
         name: String = "defaultName",
         cid: String = "",
         version: String = "",
         manager: DeviceManager) {
        self.properties = properties
        self.name = name
        self.cid = cid
        self.version = version
        self.manager = manager
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        properties = try container.decode([String: CodableValue].self, forKey: .properties)
        name = try container.decode(String.self, forKey: .name)
        cid = try container.decode(String.self, forKey: .cid)
        version = try container.decode(String.self, forKey: .version)
        manager = try container.decode(DeviceManager.self, forKey: .manager)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(properties, forKey: .properties)
        try container.encode(name, forKey: .name)
        try container.encode(cid, forKey: .cid)
        try container.encode(version, forKey: .version)
        try container.encode(manager, forKey: .manager)
    }
    
    
    func copyWithSameManager() -> Device {
        let device = Device(properties: properties,
                            name: name,
                            cid: cid,
                            version: version,
                            manager: manager!)
        return device
    }
    
    func updState() {
        manager?.setProperties(properties: properties)
    }
}

extension Device: Hashable {
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.manager == rhs.manager
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(manager)
    }
}

