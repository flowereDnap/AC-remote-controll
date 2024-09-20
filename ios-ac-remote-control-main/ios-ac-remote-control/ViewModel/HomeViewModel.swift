

import Foundation
import Combine
import SwiftUI

class HomeViewModel : ObservableObject {
    @Published var devices: [DeviceViewModel] = []
    @Published var presets: [PresetViewModel] = []
    @Published var currentPreset: PresetViewModel {
        didSet {
            //TODO
        }
    }
    
    var subscription: AnyCancellable? = nil

    func move(deviceVM: DeviceViewModel, from initialRoom: RoomViewModel?, to destinationRoom: RoomViewModel) {
        guard let device = deviceVM.device else {
            return
        }
        
        destinationRoom.room.add(device: device)
        destinationRoom.devicesVM.append(deviceVM)
    
        if let initialRoom = initialRoom {
            initialRoom.room.remove(device: device)
            if let index = initialRoom.devicesVM.firstIndex(of: deviceVM) {
                initialRoom.devicesVM.remove(at: index)
            }
        }
    }
    
    init( presets: [PresetViewModel]) {
        
        
        self.presets = presets
        self.currentPreset = presets.first(where: {$0.name == "current"}) ?? PresetViewModel(rooms: RoomViewModel.roomViewModel, name: "current")
        self.devices = currentPreset.rooms.flatMap{$0.devicesVM}
        self.devices.append(DeviceViewModel.deviceViewModels[3])
        
        subscription = currentPreset.objectWillChange.sink { [weak self] (_) in
            self?.objectWillChange.send()
        }
    }
    
    func createRoom(name: String) {
        var newRoom = Room(name: name, devices: [])
        var newRoomVM = RoomViewModel(room: newRoom)
        for preset in presets {
            preset.rooms.append(newRoomVM)
        }
    }
    
    func deleteRoom(roomVM: RoomViewModel) {
        if let index = Model.shared.rooms.firstIndex(where: { $0 == roomVM.room }) {
            Model.shared.rooms.remove(at: index)
            Model.save()
            for preset in presets {
                if let index = preset.rooms.firstIndex(where: { $0 == roomVM })
                {
                    preset.rooms.remove(at: index)
                }
            }
        }
    }
    
    func startDeviceCreation(status: Binding<Bool>) /*-> DeviceViewModel */{
        let newDeviceManager = DeviceManager(port: 7000)//TODO
        //return DeviceViewModel(properties: newDeviceManager.device?.properties)
    }
    
    func testStartDeviceCreation() -> DeviceViewModel {
        let newDeviceVM = DeviceViewModel(properties: DeviceViewModel.def, name: "")
        self.devices.append(newDeviceVM)
        return newDeviceVM
    }
    
    static var viewModel = HomeViewModel(
                                         presets: [ PresetViewModel(rooms: RoomViewModel.roomViewModel, name: "home"),
                                                    PresetViewModel(rooms: RoomViewModel.roomViewModel, name: "away"),
                                                    PresetViewModel(rooms: RoomViewModel.roomViewModel, name: "current")])
}
