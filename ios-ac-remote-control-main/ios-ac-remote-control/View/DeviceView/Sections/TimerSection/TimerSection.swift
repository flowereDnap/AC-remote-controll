

import SwiftUI

struct Timer: Hashable {
    var time: Date
    var days: [String]
    var type: Bool
    
    static func example() -> [Timer] {
        [Timer(time: Date(), days: ["Monday"], type: true)]
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
        hasher.combine(days)
        hasher.combine(type)
    }
}

struct TimerSection: View {
    @EnvironmentObject var viewModel: DeviceViewModel
    
    var timers: [Timer] = []
    
    var body: some View {
        ZStack{
            VStack(spacing: 12){
                if timers.count > 0 {
                    ForEach(timers, id: \.self) { timer in
                        TimerView(_timer: timer, _color: viewModel.colors.main)
                    }
                    
                } else {
                    HStack (spacing: 12) {
                        Image("icon_info_")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("There is no timer or preset")
                            .font(.fontBold(size: 18))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                }
                NavigationLink {
                    NewTimerCreation()
                } label: {
                    Text("Add")
                        .foregroundColor(.white)
                        .font(.fontRegular(size: 16))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(RoundedRectangle(cornerRadius: 12).fill(viewModel.colors.main))
                }
                
            }
        }
        .padding(.vertical, 12)
        .background(Color.DesignSystem.background)
    }
}

#Preview {
    TimerSection()
        .environmentObject(DeviceViewModel.deviceViewModel)
}
