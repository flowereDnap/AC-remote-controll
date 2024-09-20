
import SwiftUI

struct RoomsManagmentView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State private var isSelected: Set<RoomViewModel> = []
    
    var isSelectedAll: Binding<Bool> {
            Binding(
                get: { selectedCount == viewModel.currentPreset.rooms.count && viewModel.currentPreset.rooms.count != 0 }, // Returns true if all rooms are selected
                set: { newValue in
                    if newValue {
                                        isSelected = Set(viewModel.currentPreset.rooms)
                                    } else {
                                        isSelected.removeAll()
                                    }
                }
            )
        }

    
    var selectedCount: Int {
        return isSelected.count
    }

    init(count: Int) {
        _isSelected = State(initialValue: Set<RoomViewModel>())
    }
    
    var body: some View {
        VStack{
            if viewModel.currentPreset.rooms.count == 0 {
                Text("No rooms")
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
                    
                        ForEach(viewModel.currentPreset.rooms.indices, id: \.self) { index in
                            
                            Toggle(isOn: Binding(
                                        get: { isSelected.contains(viewModel.currentPreset.rooms[index]) },
                                        set: { newValue in
                                            if newValue {
                                                isSelected.insert(viewModel.currentPreset.rooms[index])
                                            } else {
                                                isSelected.remove(viewModel.currentPreset.rooms[index])
                                            }
                                        }
                                    )) {
                                        VStack (alignment: .leading, spacing: 4) {
                                            Text(viewModel.currentPreset.rooms[index].name)
                                                .font(.fontRegular(size: 16))
                                                .tint(.black)
                                            Text("\(viewModel.currentPreset.rooms[index].devicesVM.count) equipment" )
                                                .font(.fontRegular(size: 12))
                                                .tint(.black)
                                        }
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
                for room in isSelected {
                            viewModel.deleteRoom(roomVM: room)
                        }
                        isSelected.removeAll()
            } label: {
                Text("Delete")
                    .font(.fontRegular(size: 16))
                    .tint(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(myButtonStyle(type: selectedCount != 0 ? .negative : .unavaliable))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 8)
        .navigationTitle("Selected (\(isSelectedAll.wrappedValue ? "All" : String(selectedCount)))")
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
    RoomsManagmentView(count: HomeViewModel.viewModel.currentPreset.rooms.count)
        .environmentObject(HomeViewModel.viewModel)
}
