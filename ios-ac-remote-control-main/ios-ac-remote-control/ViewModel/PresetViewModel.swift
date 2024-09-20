

import Foundation

class PresetViewModel: ObservableObject {
    
    var id = UUID().uuidString
    
    @Published var rooms: [RoomViewModel]
    
    var name: String
    var toUpdate: Bool = false
    
    init(rooms: [RoomViewModel], name: String) {
        self.rooms = rooms
        self.name = name
        
    }
    
    init(name: String) {
    
        self.rooms = []
        self.name = name
    }
    
    func copyWithSamemanager() -> PresetViewModel {
        let newPreset = PresetViewModel(name: self.name)
        newPreset.rooms = self.rooms.map{ $0.copyWithSameManager() }
        return newPreset
    }
    
    static var presetViewModel = PresetViewModel( rooms: roomViewModel, name: "current")
    static var roomViewModel = [RoomViewModel(name: "Room1", devicesVM: [DeviceViewModel.deviceViewModels[0]]),
                                RoomViewModel(name: "Room2", devicesVM: [DeviceViewModel.deviceViewModels[1],
                                                                         DeviceViewModel.deviceViewModels[2]])]
}
