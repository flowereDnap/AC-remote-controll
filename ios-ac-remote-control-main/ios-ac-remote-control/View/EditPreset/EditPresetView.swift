

import SwiftUI

struct EditPresetView: View {
    @Environment(\.dismiss) private var dismiss
    @State var presetViewModelCopy: PresetViewModel
    
    init(presetViewModelCopy: PresetViewModel) {
        self.presetViewModelCopy = presetViewModelCopy
        
    }
    
    var body: some View {
        ZStack{
            Color.DesignSystem.background.ignoresSafeArea()
            
            VStack(spacing: 20){
                Text("All devices Turner off by default, turn on and setup any needed device")
                    .font(.fontRegular(size: 14))
                    .padding(.horizontal, 31)
                
                    ScrollView(.vertical,showsIndicators: false) {
                        VStack(spacing: 12){
                            ForEach(presetViewModelCopy.rooms) { room in
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
                            
                            
                        }
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        Text("Save")
                            .font(.fontRegular(size: 16))
                            .tint(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.DesignSystem.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .navigationTitle("Settings")
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
    EditPresetView(presetViewModelCopy: PresetViewModel.presetViewModel.copyWithSamemanager())
        
}
