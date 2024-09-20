

import Foundation


class Preset: Codable {
    
    var name: String
    
    var devices: [Device] = []
    
    var rooms: [Room] = []
    
    init(name: String) {
        self.name = name
    }
    
    func on() throws {
        devices.forEach{ $0.updState() }
    }
    
    func updFromModel() {
        
        devices = Model.shared.devices.compactMap { device in
            if !devices.contains(device) {
                return device
            }
            return nil
        }
        
        rooms = Model.shared.rooms.compactMap { room in
            if !rooms.contains(room) {
                return room
            }
            return nil
        }
    }
    
}
