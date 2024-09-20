
import SwiftUI

struct RoomsList: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: HomeViewModel
    
    @State var isValidInput: Bool = false
    @State var isAlertPresented: Bool = false
    @State var newRoomName = ""
    
    
    var body: some View {
        ZStack {
            Color.DesignSystem.background.ignoresSafeArea()
            VStack{
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(spacing: 12){
                        ForEach(viewModel.currentPreset.rooms) { room in
                            NavigationLink{
                                RoomView(roomName: room.name).environmentObject(room)
                            } label: {
                                HStack{
                                    VStack (alignment: .leading, spacing: 4) {
                                        Text(room.name)
                                            .font(.fontRegular(size: 16))
                                            .tint(.black)
                                        Text("\(room.devicesVM.count) equipment" )
                                            .font(.fontRegular(size: 12))
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
                        NavigationLink{
                            RoomsManagmentView(count: viewModel.currentPreset.rooms.count)
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
                Button {
                    isAlertPresented = true
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
            .padding(.horizontal, 20)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Rooms managment")
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
            RoomNameAlert(title: "Create New Room",
                          isValidInput: $isValidInput,
                          isPresented: $isAlertPresented,
                          okAction: {
                              viewModel.createRoom(name: newRoomName)
            }, containedView:
                            NewRoomAlertView(result: $newRoomName, isValidInput: $isValidInput)
                .padding(0)
            )
        )
    }
    
}

#Preview {
    RoomsList()
        .environmentObject(HomeViewModel.viewModel)
}
