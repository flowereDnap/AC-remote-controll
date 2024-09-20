
import SwiftUI

struct DevicesManagmentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: RoomViewModel
    
    @State private var selectedDevices: Set<DeviceViewModel> = []
        
        var selectedCount: Int {
            return selectedDevices.count
        }
        
        init(count: Int) {
            // Initialize with an empty set
            _selectedDevices = State(initialValue: Set<DeviceViewModel>())
        }
    
    var isSelectedAll: Binding<Bool> {
            Binding(
                get: { selectedCount == viewModel.devicesVM.count && viewModel.devicesVM.count != 0 }, // Returns true if all rooms are selected
                set: { newValue in
                    if newValue {
                        selectedDevices = Set(viewModel.devicesVM)
                                    } else {
                                        selectedDevices.removeAll()
                                    }
                }
            )
        }
    
    var body: some View {
        VStack{
            if viewModel.devicesVM.count == 0 {
                Text("No devices in this room")
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
                    
                        ForEach(viewModel.devicesVM.indices, id: \.self) { index in
                            Toggle(isOn: Binding(
                                get: { selectedDevices.contains(viewModel.devicesVM[index]) },
                                set: { newValue in
                                    if newValue {
                                        selectedDevices.insert(viewModel.devicesVM[index])
                                    } else {
                                        selectedDevices.remove(viewModel.devicesVM[index])
                                    }
                                })) {
                                Text(viewModel.devicesVM[index].name)
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
            NavigationLink {
                DevicesMoveView(belongingRoom: viewModel, devicesToMove: Array(selectedDevices))
            } label: {
                Text("Move to room")
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
    DevicesManagmentView(count: RoomViewModel.roomViewModel[1].devicesVM.count)
        .environmentObject(RoomViewModel.roomViewModel[1])
}


struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
                .padding()
        }
        .onTapGesture { configuration.isOn.toggle() }
        
    }
}
