import SwiftUI

struct MainView: View {
    @EnvironmentObject var model : HomeViewModel
    
    init() {
        UITableView.appearance().backgroundColor = .clear
      }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.DesignSystem.background.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Scene")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.fontBold(size: 18))
                    
                    MainSection1()
                    RoomsAndDevicesSection()
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 38)
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: NavigationLink(destination: {
                        SettingsView()
                    }, label: {
                        Image("icon_settings_")
                    }),
                    trailing: NavigationLink(destination: {
                        AddDeviceView()
                        //ACConnectionView()
                    }, label: {
                        Image("icon_plus_")
                    })
                )
            }
        }
        
    }
    
}

#Preview {
    MainView()
        .environmentObject(HomeViewModel.viewModel)
}
