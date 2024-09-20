
import SwiftUI

struct AddDevicesToRoomView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var roomToAdd: RoomViewModel
    
    @State var devicesVM: [DeviceViewModel]
    
    @State private var selectedDevices: Set<DeviceViewModel> = []
        
        var selectedCount: Int {
            return selectedDevices.count
        }
        
    init(devices: [DeviceViewModel]) {
        _devicesVM = State(initialValue: devices)
        _selectedDevices = State(initialValue: Set<DeviceViewModel>())
    }
    
    var isSelectedAll: Binding<Bool> {
            Binding(
                get: { selectedCount == devicesVM.count && devicesVM.count != 0 }, // Returns true if all rooms are selected
                set: { newValue in
                    if newValue {
                        selectedDevices = Set(devicesVM)
                                    } else {
                                        selectedDevices.removeAll()
                                    }
                }
            )
        }
    
    var body: some View {
        VStack{
            if devicesVM.count == 0 {
                Text("All devices are destributed among rooms")
            }
            else {
            Toggle(isOn: isSelectedAll) {
                Text("Select all")
                    .font(.fontRegular(size: 16))
                    .tint(.black)
                    .padding()
            }
            .toggleStyle(CheckboxStyle())
            .frame(maxWidth: .infinity)
            
            ScrollView(.vertical,showsIndicators: false) {
                VStack(spacing: 12) {
                    
                        ForEach(devicesVM.indices, id: \.self) { index in
                            Toggle(isOn: Binding(
                                get: { selectedDevices.contains(devicesVM[index]) },
                                set: { newValue in
                                    if newValue {
                                        selectedDevices.insert(devicesVM[index])
                                    } else {
                                        selectedDevices.remove(devicesVM[index])
                                    }
                                })) {
                                Text(devicesVM[index].name)
                                    .padding()
                            }
                            .toggleStyle(CheckboxStyle())
                            .frame(maxWidth: .infinity)
                            .background(Color.DesignSystem.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                }
                
            }
            Spacer()
            Button {
                for device in selectedDevices{
                    device.room = roomToAdd
                    roomToAdd.devicesVM.append(device)
                }
            } label: {
                Text("Add to room")
                    .font(.fontRegular(size: 16))
                    .padding()
                    .frame(maxWidth: .infinity)
                    
            }
            .buttonStyle(myButtonStyle(type: selectedCount != 0 ? .usual : .unavaliable))
        }
        .padding()
        .navigationTitle("Selected (\(isSelectedAll.wrappedValue ? "All" : String(selectedCount)))")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 8)
        .background(Color.DesignSystem.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button {
                dismiss()
            } label: {
                Image("icon_back_")
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddDevicesToRoomView(devices: HomeViewModel.viewModel.devices.filter{$0.room == nil})
        .environmentObject(RoomViewModel.roomViewModel[1])
}
