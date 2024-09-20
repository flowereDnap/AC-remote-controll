

import SwiftUI

struct DeviceSettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    @State var version: String = "ver 1"
    @State var mac: String = "504c"
    
    var body: some View {
        VStack{
            HStack(alignment: .top) {
                Text("General Info")
                    .font(.fontRegular(size: 16))
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text("MID: \(version)")
                        .font(.fontMedium(size: 16))
                    Text("MAC: \(mac)")
                        .font(.fontMedium(size: 16))
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            
            HStack(alignment: .top) {
                Text("Device name")
                    .font(.fontRegular(size: 16))
                
                Spacer()
                
                TextField("", text: $deviceViewModel.name)
                    .font(.fontMedium(size: 16))
                    .scaledToFit()
                    .multilineTextAlignment(.trailing)
                    
            }
            .padding()
            .background(.white)
            .cornerRadius(12)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Delete")
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
            }
            .buttonStyle(myButtonStyle(type: .negative))
            

        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.DesignSystem.background)
        .padding(.vertical, 8)
        .background(Color.DesignSystem.background)
        .navigationTitle(deviceViewModel.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            leading: Button {
                dismiss()
            } label: {
                Image("icon_back_")
            },
            trailing: Button {
                dismiss()
            } label: {
                Text("Save")
                    .tint(.blue)
            }
        )
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    DeviceSettingsView()
        .environmentObject(DeviceViewModel.deviceViewModel)
}
