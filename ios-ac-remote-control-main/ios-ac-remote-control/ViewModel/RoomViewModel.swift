

import Foundation

class RoomViewModel: Identifiable, Equatable, ObservableObject {
    
    var id: String {
        get {
            return room.id
        }
    }
    
    var room: Room

    @Published var name: String
    
    @Published var devicesVM: [DeviceViewModel] = []
    
    init(room: Room) {
        self.room = room
        self.name = room.name
        var deviceVM: DeviceViewModel
        for device in room.devices {
            deviceVM = DeviceViewModel(properties: device.properties)
            deviceVM.room = self
            devicesVM.append(deviceVM)
        }

    }
    
    init(name: String , devicesVM: [DeviceViewModel]) {
        self.devicesVM = devicesVM
        self.room = Room(name: name, devices: [])
        self.name = name
        for device in devicesVM {
            device.room = self
        }
    }
    
    func copyWithSameManager() -> RoomViewModel {
        //TODO
        let newRoom = RoomViewModel(name: self.name, devicesVM: self.devicesVM.map{$0.copyWithSameManager()})
        newRoom.room = self.room.copyWithSameManager()
        return newRoom
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    func setName(name: String) {
        if name.isValidText() {
            self.name = name
        }
        //TODO
        room.setName(name: name)
    }
    
    static var roomViewModel = [RoomViewModel(name: "Room1", devicesVM: [DeviceViewModel.deviceViewModels[0]]),
                                RoomViewModel(name: "Room2", devicesVM: [DeviceViewModel.deviceViewModels[1],
                                                                         DeviceViewModel.deviceViewModels[2]])]
}

extension RoomViewModel: Hashable {
    static func == (lhs: RoomViewModel, rhs: RoomViewModel) -> Bool {
        return lhs.room.id == rhs.room.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(room.id)
    }
}
