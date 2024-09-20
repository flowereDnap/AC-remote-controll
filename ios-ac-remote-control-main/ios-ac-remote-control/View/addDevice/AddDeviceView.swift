
import SwiftUI


struct AddDeviceView: View {
    @Environment(\.dismiss) private var dismiss
    @State var text: String = ""
    
    var deviceTypes: [String] = ["AC", "Commercial air conditioner"]
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            TextField("Search device type", text: $text)
                .padding()
                .background(.white)
            
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.DesignSystem.darkGrey, lineWidth: 1)
                )
                .overlay(alignment: .trailing, content: {
                    Image("icon_search_")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 16)
                    
                })
                .padding(.bottom, 8)
            Text("Please confirm the device is at reset status If the device can't be found, add the device by the category")
                .font(.fontRegular(size: 14))
                .padding(.bottom, 20)
            
            ForEach(deviceTypes, id: \.self) { type in
                
                NavigationLink {
                    //AddingInstructionsView(type: type)
                    ACConnectionViewX()
                    //ACConnectionView()
                } label: {
                    Text(type)
                        .font(.fontMedium(size: 16))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.DesignSystem.skyBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .tint(.black)
                }
            }
            Spacer()
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.DesignSystem.background)
        .navigationTitle("Select device type")
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
    AddDeviceView()
}
