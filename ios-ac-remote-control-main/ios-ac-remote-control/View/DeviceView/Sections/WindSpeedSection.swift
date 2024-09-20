

import SwiftUI

enum WindSpeed: String, CaseIterable, Identifiable {
    case Auto
    case Quite
    case Turbo
    
    var id: Self {self}
}

struct Position {
    var name: String
    var icon: String
}

struct WindSpeedSection: View {
    
    @EnvironmentObject var deviceViewModel: DeviceViewModel
    
    
    @State var selectedSpeed: WindSpeed = .Auto
    private var positions = [Position(name: "Up-Down", icon: "icon_conditioner")]
    
    var body: some View {
        VStack(spacing:0) {
            segmentedSlider(
                WindSpeed.allCases,
                selection: selectedSpeed,
                cornerRadius: 8.0
            ) { item in
                Text(item.rawValue.capitalized)
                    .padding(.vertical, 0)
                    .padding(.horizontal, 20)
                    .font(.fontRegular(size: 14))
                    .foregroundColor(selectedSpeed == item ? .white : nil)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.150)) {
                            selectedSpeed = item
                        }
                    }
            }
            .borderColor(deviceViewModel.colors.secondary)
            .borderWidth(1)
            .padding()
            .accentColor(deviceViewModel.colors.main)
            
            HStack {
                ForEach(0..<4) { index in
                    if index < positions.count {
                        let position = positions[index]
                        Button {
                            
                        } label: {
                            VStack {
                                    Image(position.icon)
                                        .renderingMode(.template)
                                        .foregroundColor( true ? Color.DesignSystem.white : Color.DesignSystem.darkGrey)
                                        .padding(10)
                                        .background(  true  ? deviceViewModel.colors.main : Color.DesignSystem.lightGrey)
                                        .clipShape(Circle())
                                
                                Text(position.name)
                                    .font(.fontRegular(size: 14))
                                    .foregroundColor(Color.DesignSystem.black)
                                    .lineLimit(1)
                            
                            }
                            .frame(maxWidth: .infinity)
                        }
                    } else {
                        VStack {
                            
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
    .background(Color.DesignSystem.background)
        
    }
}

#Preview {
    WindSpeedSection()
        .environmentObject(DeviceViewModel.deviceViewModel)
}
