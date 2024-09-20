
import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack{
            VStack (alignment: .leading, spacing: 12) {
                NavigationLink {
                    PresetsView()
                } label: {
                    HStack {
                        Image("icon_folder_")
                            .frame(width: 44, height: 44)
                            .background(.blue)
                            .clipShape(Circle())
                        
                        Text("Scene")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                NavigationLink {
                    RoomsList().environmentObject(HomeViewModel.viewModel)
                } label: {
                    HStack {
                        Image("icon_smart_home_")
                            .frame(width: 44, height: 44)
                            .background(.blue)
                            .clipShape(Circle())
                        Text("Room Managment")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                NavigationLink {
                    
                } label: {
                    HStack {
                        Image("icon_google_docs_")
                            .frame(width: 44, height: 44)
                            .background(.blue)
                            .clipShape(Circle())
                        Text("Terms of use")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                NavigationLink {
                    
                } label: {
                    HStack {
                        Image("icon_security_shield_")
                            .frame(width: 44, height: 44)
                            .background(.blue)
                            .clipShape(Circle())
                        Text("Privacy Policy")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                            .lineLimit(2)
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
        }

        .background(Color.DesignSystem.background)
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
    SettingsView()
}
