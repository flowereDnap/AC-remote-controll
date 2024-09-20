

import SwiftUI

struct DeviceListCell: View {
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    
                    Toggle(isOn: $deviceViewModel.power.value)
                    {
                        NavigationLink {
                            DeviceView()
                                .environmentObject(deviceViewModel)
                        } label: {
                            Text(deviceViewModel.name)
                                .padding(0)
                                .font(.fontBold(size: 16))
                                .scaledToFit()
                                .tint(.black)
                        }

                    }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .font(.fontMedium(size: 16))
                        .tint(deviceViewModel.colors.main)
                    
                }
                
                Spacer()
                
                if !deviceViewModel.power.value {
                    HStack (alignment: .center) {
                        Text("Power Off")
                            .padding(0)
                            .font(.fontBold(size: 16))
                            .scaledToFit()
                        Spacer()
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                } else {
                    HStack (alignment: .center) {
                        HStack{
                            Image(deviceViewModel.mode.icon)
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(deviceViewModel.colors.main)
                                .frame(width: 24, height: 24)
                                .padding(0)
                            
                            Text(deviceViewModel.mode.value)
                                .font(.fontBold(size: 16))
                                .padding(0)
                                .scaledToFit()
                                .foregroundColor(deviceViewModel.colors.main)
                        }
                        .padding(0)
                        Spacer()
                        
                        HStack (spacing: 0){
                            Button {
                                deviceViewModel.temperature.value = deviceViewModel.temperature.value - 1
                            } label: {
                                ZStack{
                                    Circle().fill(deviceViewModel.colors.main)
                                        .frame(width: 44, height: 44)
                                Image("icon_minus_")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                        }.padding(2)
                            }
                            Spacer()
                            HStack (spacing: 0) {
                                Text(String(Int(deviceViewModel.temperature.value)))
                                    .font(.fontBold(size: 22))
                                
                                Image(deviceViewModel.isFahrenheit.icon)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 29, height: 29)
                            }.padding(0)
                            Spacer()
                            Button {
                                deviceViewModel.temperature.value = deviceViewModel.temperature.value + 1
                            } label: {
                                ZStack{
                                    Circle().fill(deviceViewModel.colors.main)
                                        .frame(width: 44, height: 44)
                                Image("icon_plus_white")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                        }.padding(2)
                                    
                            }
                            
                        }
                        .frame(width: 180)
                        .background(RoundedRectangle(cornerRadius: 40)
                            .fill(deviceViewModel.colors.secondary))
                    }
                    .frame(height: 48)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                }
            }
            
            .background(
                NavigationLink(destination: {
                    DeviceView()
                        .environmentObject(deviceViewModel)
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(deviceViewModel.power.value ? Color.DesignSystem.white : Color.DesignSystem.lightGrey)
                })
            )
            
        }
        .padding(0)
        .background(Color.DesignSystem.background)
        .frame(height: 122)
        .frame(maxWidth: .infinity)
        .listRowSeparator(.hidden)
        .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

#Preview {
    DeviceListCell()
        .environmentObject(DeviceViewModel.deviceViewModel)
    
}
