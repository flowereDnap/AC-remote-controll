
import SwiftUI

struct DevicesMoveView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var homeModel: HomeViewModel
    
    @State var belongingRoom: RoomViewModel?
    @State var isAlertPresented: Bool = false
    @State var isValid: Bool = true
    @State var roomToMove: RoomViewModel?
    
    var devicesToMove: [DeviceViewModel]
    
    var body: some View {
        ZStack{
            VStack{
                Text("Belonging room")
                    .font(.fontRegular(size: 16))
                    .tint(.black)
                    .padding(.bottom, 12)
                
                Text(belongingRoom?.name ?? "Not set yet")
                    .font(.fontRegular(size: 16))
                    .tint(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.DesignSystem.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom, 22)
                
                
                Text("Move to room")
                    .font(.fontRegular(size: 16))
                    .tint(.black)
                    .padding(.bottom, 12)
                
                
                
                ScrollView(.vertical,showsIndicators: false) {
                    VStack(spacing: 8) {
                        if homeModel.currentPreset.rooms.count == 1 {
                            Text("No other rooms")
                        }
                        else {
                            ForEach(homeModel.currentPreset.rooms) { room in
                                if room != belongingRoom {
                                    Button {
                                        //TODO
                                        roomToMove = room
                                        isAlertPresented = true
                                        
                                    } label: {
                                        VStack (alignment: .leading, spacing: 4) {
                                            Text(room.name)
                                                .font(.fontRegular(size: 16))
                                                .tint(.black)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                            
                                        }
                                    }
                                    
                                    .background(Color.DesignSystem.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                        
                        
                    }
                    
                }
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 38)
        .navigationTitle("Move Room")
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
            RoomNameAlert(title: "Notice",
                          isValidInput: $isValid,
                          isPresented: $isAlertPresented,
                          okAction: {
                              if let roomToMove = roomToMove {
                                  for device in devicesToMove {
                                      homeModel.move(deviceVM: device, from: belongingRoom, to: roomToMove)
                                  }
                                  self.belongingRoom = roomToMove
                              }
                              
                          }, containedView:
                            Text("Selected devices will be moved from \(belongingRoom?.name ?? "") to \(roomToMove?.name ?? "")")
                         )
        )
    }
}


#Preview {
    DevicesMoveView(belongingRoom: RoomViewModel.roomViewModel[1], devicesToMove: [])
        .environmentObject(HomeViewModel.viewModel)
}
