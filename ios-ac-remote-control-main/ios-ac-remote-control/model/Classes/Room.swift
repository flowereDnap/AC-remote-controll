import Foundation

class Room : Codable, ObservableObject, Identifiable {
    var name: String {
        didSet {
            Model.save()
        }
    }
    var devices: [Device] {
        didSet {
            Model.save()
        }
    }
    var id: String
    
    init(name: String, devices: [Device]) {
        self.name = name
        self.devices = devices
        self.id = UUID().uuidString
        
        Model.shared.rooms.append(self)
    }
    
    func remove(device: Device) {
        if let index = devices.firstIndex(of: device) {
            devices.remove(at: index)
        }
        Model.save()
    }
    
    func add(device: Device) {
        devices.append(device)
        Model.save()
    }
    
    func setName(name: String) {
        if name.isValidText() {
            self.name = name
        }
        
        Model.save()
    }
    
    
    func copyWithSameManager() -> Room {
        let room = Room(name: self.name, devices: devices.map{ device in
            let newDevice = device.copyWithSameManager()
            newDevice.properties["power"] = CodableValue(0)
            return newDevice
        })
        return room
    }
    
    
}

extension Room: Hashable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
