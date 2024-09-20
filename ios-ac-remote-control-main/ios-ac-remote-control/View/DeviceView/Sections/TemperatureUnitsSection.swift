

import SwiftUI

struct TemperatureUnitsSection: View {
    
    @EnvironmentObject var viewModel: DeviceViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            VStack{
                Button {
                    if viewModel.isFahrenheit.value {
                        viewModel.isFahrenheit.value.toggle()
                    }
                }
            label: {
                VStack (spacing: 20){
                    
                    
                    Image("icon_celsius_")
                        .renderingMode(.template)
                        .foregroundColor(!viewModel.isFahrenheit.value ? Color.DesignSystem.white : Color.DesignSystem.darkGrey)
                        .padding(10)
                        .background( !viewModel.isFahrenheit.value  ? viewModel.colors.main : Color.DesignSystem.lightGrey)
                        .clipShape(Circle())
                    
                    Text("Celsius")
                        .font(.fontRegular(size: 14))
                        .foregroundColor(Color.DesignSystem.black)
                    
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
            }
            }
            
            
            VStack{
                Button {
                    if !viewModel.isFahrenheit.value {
                        viewModel.isFahrenheit.value.toggle()
                    }
                } label: {
                    VStack (spacing: 20) {
                        Image("icon_fahrenheit_")
                            .renderingMode(.template)
                            .foregroundColor(viewModel.isFahrenheit.value ? Color.DesignSystem.white : Color.DesignSystem.darkGrey)
                            .padding(10)
                            .background( viewModel.isFahrenheit.value  ? viewModel.colors.main : Color.DesignSystem.lightGrey)
                            .clipShape(Circle())
                        Text("Fahrenheit")
                            .font(.fontRegular(size: 14))
                            .foregroundColor(Color.DesignSystem.black)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
                    
                }
                
            }
        }
        .background(Color.DesignSystem.background)
    }
}

#Preview {
    TemperatureUnitsSection()
        .environmentObject(DeviceViewModel.deviceViewModel)
}
