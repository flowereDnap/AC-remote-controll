
import SwiftUI

struct EditRoomPresetView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var viewModel: RoomViewModel
    
    @State var isAlertPresented: Bool = false
    
    @State var roomName: String

    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    VStack (alignment: .leading, spacing: 4) {
                        Text(roomName)
                            .font(.fontRegular(size: 16))
                            .tint(.black)
                            
                    }

                    
                }
                .frame(maxWidth: .infinity)
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
                        
                    }
                    
                }
                Spacer()
                
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
    }
}

#Preview {
    EditRoomPresetView(roomName: RoomViewModel.roomViewModel[0].name)
        .environmentObject(RoomViewModel.roomViewModel[0])
}

