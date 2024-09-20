

import SwiftUI

struct ModesSection: View {
    
    @EnvironmentObject var viewModel: DeviceViewModel
    
    var body: some View {
        
            HStack{
                
                ForEach(Modes.allCases, id: \.self) { mode in
                    
                    Button {
                        viewModel.mode.value = mode.name
                    } label: {
                        VStack{
                            Image(Modes.getIcon(mode.rawValue))
                                    .renderingMode(.template)
                                    .foregroundColor(mode.name == viewModel.mode.value ? Color.DesignSystem.white : Color.DesignSystem.darkGrey)
                                    .padding(10)
                                    .background( mode.name == viewModel.mode.value  ? viewModel.colors.main : Color.DesignSystem.lightGrey)
                                    .clipShape(Circle())

                            Text(mode.name)
                                .font(.fontRegular(size: 14))
                                .foregroundColor(Color.DesignSystem.black)

                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                }
                
            }
            .padding(.vertical, 12)
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
            .background(Color.DesignSystem.background)
        
    }

}

#Preview {
    ModesSection()
        .environmentObject(DeviceViewModel.deviceViewModel)
}
