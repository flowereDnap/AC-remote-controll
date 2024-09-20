
import SwiftUI

struct RoomView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var viewModel: RoomViewModel
    
    @State var isAlertPresented: Bool = false
    
    @State var isValidInput = false
    @State var roomName: String
    @State var newName = ""
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    VStack (alignment: .leading, spacing: 4) {
                        Text(roomName)
                            .font(.fontRegular(size: 16))
                            .tint(.black)
                    }
                    Spacer()
                    Button {
                        isAlertPresented = true
                    } label: {
                        Image("icon_edit_")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16.75, height: 16.75)
                    }
                }
                .padding()
                .background(Color.DesignSystem.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.bottom, 20)
                
                
                
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(spacing: 12) {
                        if viewModel.devicesVM.count == 0 {
                            Text("No devices in this room")
                        }
                        else {
                            ForEach(viewModel.devicesVM) { device in
                                
                                NavigationLink{
                                    DeviceView()
                                        .environmentObject(device)
                                } label: {
                                    HStack{
                                        VStack (alignment: .leading, spacing: 4) {
                                            Text(device.name)
                                                .font(.fontRegular(size: 16))
                                                .tint(.black)
                                            
                                        }
                                        Spacer()
                                        
                                        Image("icon_back_")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24).rotationEffect(Angle(degrees: 180))
                                    }
                                }
                                .padding()
                                .background(Color.DesignSystem.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        NavigationLink{
                            DevicesManagmentView(count: viewModel.devicesVM.count)
                                .environmentObject(viewModel)
                        } label: {
                            Text("Manage")
                                .font(.fontRegular(size: 16))
                                .tint(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.DesignSystem.skyBlue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    }
                    
                }
                Spacer()
                NavigationLink {
                    AddDevicesToRoomView(devices: homeVM.devices.filter{$0.room == nil})
                        .environmentObject(viewModel)
                } label: {
                    Text("Add")
                        .font(.fontRegular(size: 16))
                        .tint(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.DesignSystem.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
        }
        .padding()
        .navigationTitle("\(viewModel.name) info")
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
        .overlay(
            RoomNameAlert(title: "New Room Name",
                          isValidInput: $isValidInput,
                          isPresented: $isAlertPresented,
                          okAction: {
                              viewModel.name = newName
                              roomName = newName
                              newName = ""
            }, containedView:
                            TextFieldView(text: $newName, validInput: $isValidInput, placeholder: "Enter new room name")
            )
        )
    }
}

#Preview {
    RoomView(roomName: RoomViewModel.roomViewModel[0].name)
        .environmentObject( HomeViewModel.viewModel)
        .environmentObject( RoomViewModel.roomViewModel[0])
        
}

