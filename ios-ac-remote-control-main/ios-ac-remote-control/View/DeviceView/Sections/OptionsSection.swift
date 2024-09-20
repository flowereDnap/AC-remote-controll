

import SwiftUI

struct MenuElement {
    var name: String
    var icon: String
    
}



struct OptionsSection: View {
    @ObservedObject var viewModel: DeviceViewModel
    
        
    var body: some View {
        VStack (spacing: 12) {
            ForEach(0..<((viewModel.options.count - 1) / 5 + 1), id: \.self) { rowNumber in
                HStack (alignment: .firstTextBaseline){
                    ForEach(0..<5) { index in
                        let optionIndex = index + rowNumber * 5
                        if optionIndex < viewModel.options.count {
                            let option = viewModel.options[optionIndex]
                            Button {
                                option.value.toggle()
                            } label: {
                                VStack {
                                    let icon = option.icon
                                    Image(String(icon))
                                            .renderingMode(.template)
                                            .foregroundColor(option.value == true ? Color.DesignSystem.white : Color.DesignSystem.darkGrey)
                                            .padding(10)
                                            .background( option.value == true  ? viewModel.colors.main : Color.DesignSystem.lightGrey)
                                            .clipShape(Circle())
                                    
                                    Text(option.name)
                                        .font(.fontRegular(size: 14))
                                        .foregroundColor(Color.DesignSystem.black)
                                        .lineLimit(2)
                                
                                }
                                .frame(maxWidth: .infinity)
                             }
                            .disabled(!option.isChangeble)
                            
                        
                        } else {
                            VStack {
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                
            }
        }
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
        .background(Color.DesignSystem.background)
    }
}

#Preview {
    OptionsSection(viewModel: DeviceViewModel.deviceViewModel)
}
