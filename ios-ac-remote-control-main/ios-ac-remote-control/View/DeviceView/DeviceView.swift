

import SwiftUI

enum SelectedSection: String, CaseIterable, Identifiable{
    case Mode
    case WindSpeed = "Wind Speed"
    case Timer
    
    var id: Self { self }
}

struct DeviceView: View {
    @Environment(\.dismiss) private var dismiss
    // min 0.15, max 0.85 -> range 0.7
    @State var progressValue: Float = 0
    
    
    
    @EnvironmentObject var deviceViewModel: DeviceViewModel

    @State var selectedSection: SelectedSection = .Mode
    private let deviceType: String = "Air Condition"
    
    
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack {
                HStack (spacing: 0) {
                    Toggle(deviceType, isOn: $deviceViewModel.power.value)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .font(.fontMedium(size: 22))
                        .tint(deviceViewModel.colors.main)
                        
                }
                
                    
                
                
                if deviceViewModel.power.value {
                    VStack (spacing: 32 ) {
                        HStack (spacing: 0) {
                            
                            Button {
                                deviceViewModel.temperature.value -= 1
                                let tempOffset = deviceViewModel.isFahrenheit.value ? 68.0 : 20.0
                                let range: Float = deviceViewModel.isFahrenheit.value ? 18.0 : 10.0
                                progressValue = Float(deviceViewModel.temperature.value - tempOffset) / range * 0.7 + 0.15
                                
                            } label: {
                                    Image("icon_minus_")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color.DesignSystem.white)
                                        .padding(10)
                                        .background(deviceViewModel.colors.main)
                                        .clipShape(Circle())
                            }
                            
                            
                            Spacer()
                            VStack(spacing: 0) {
                                ZStack (alignment: .bottom){
                                    ZStack {
                                        HalfCircularProgressBar(progress: self.$progressValue, colorBackgound: deviceViewModel.colors.secondary, colorForeground: deviceViewModel.colors.main)
                                            .frame(width: 200, height: 200, alignment: .center)
                                            .padding(0)
                                            .onAppear(perform: {
                                                let tempOffset = deviceViewModel.isFahrenheit.value ? 68.0 : 20.0
                                                let range: Float = deviceViewModel.isFahrenheit.value ? 18.0 : 10.0
                                                progressValue = Float(deviceViewModel.temperature.value - tempOffset) / range * 0.7 + 0.15
                                            })
                                            .animation(.easeOut)
                                            
                                        
                                        
                                        Circle()
                                            .fill(Color.DesignSystem.white)
                                            .frame(width: 128, height: 128, alignment: .center)
                                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                            .padding(0)
                                        HStack(spacing: 0) {
                                            
                                            
                                            Text(String(Int(deviceViewModel.temperature.value)))
                                                .font(.fontRegular(size: 32))
                                                .padding(.trailing, 0)
                                            
                                            Image(deviceViewModel.isFahrenheit.icon)
                                               .resizable()
                                               .frame(width: 32, height: 32)
                                           
                                            
                                        }
                                        .padding(0)
                                    }
                                    
                                    .padding(0)
                                    Text( deviceViewModel.mode.value + ", " + "Medium")
                                        .font(.fontRegular(size: 12))
                                        .foregroundColor(Color.DesignSystem.darkGrey)
                                        .padding(10)
                                }
                            }
                            Spacer()
                            Button {
                                deviceViewModel.temperature.value += 1
                                let tempOffset = deviceViewModel.isFahrenheit.value ? 68.0 : 20.0
                                let range: Float = deviceViewModel.isFahrenheit.value ? 18.0 : 10.0
                                progressValue = Float(deviceViewModel.temperature.value - tempOffset) / range * 0.7 + 0.15
                                
                            } label: {
                                    Image("icon_plus_white")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(Color.DesignSystem.white)
                                        .padding(10)
                                        .background( deviceViewModel.colors.main)
                                        .clipShape(Circle())
                            }
                            
                        }
                        

                        
                        VStack (spacing: 16) {
                            segmentedSlider(
                                SelectedSection.allCases,
                                selection: selectedSection
                            ) { item in
                                Text(item.rawValue.capitalized)
                                    .font(.fontRegular(size: 14))
                                    .foregroundColor(selectedSection == item ? .white : nil)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.150)) {
                                            selectedSection = item
                                        }
                                    }
                            }
                            .accentColor(deviceViewModel.colors.main)
                            
                            switch selectedSection {
                            case .Mode:
                                ModesSection()
                                    
                                
                            case .WindSpeed:
                                WindSpeedSection()
                                    
                                
                            case .Timer:
                                TimerSection()
                                    
                                
                            }
                        }
                        
                        VStack (spacing: 16){
                            HStack{
                                Image("icon_leaf_")
                                Text("Options")
                                Spacer()
                            }
                            
                            OptionsSection(viewModel: deviceViewModel)
                                
                                
                        }
                        
                        
                        VStack (spacing: 16){
                            HStack{
                                Image("icon_temperature_")
                                Text("Temperature Units")
                                Spacer()
                            }
                            
                            TemperatureUnitsSection()
                                .environmentObject(deviceViewModel)
                                
                        }
                        
                        Spacer()
                    }
                    
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
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
            trailing: NavigationLink(destination: DeviceSettingsView().environmentObject(DeviceViewModel.deviceViewModel), label: {
                Image("icon_menu_2_")
            })
        )
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    DeviceView()
        .environmentObject(DeviceViewModel.deviceViewModel)
}


