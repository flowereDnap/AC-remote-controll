

import SwiftUI

struct TimerView: View {
    var timer: Timer
    @State var time: Date = Date()
    @State var on: Bool = true
    @State var type: Bool = true
    @State var days: [String] = ["Monday"]
    var color: Color
    
    init(_timer: Timer, _color: Color) {
        timer = _timer
        color = _color
        time = timer.time
        type = timer.type
        days = timer.days
        
    }
    
    var body: some View {
        ZStack{
        HStack(spacing: 12){
            VStack(alignment: .leading, spacing: 8) {
                Text("Time:")
                    .font(.fontMedium(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
                Text("Repeat:")
                    .font(.fontMedium(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
                Text("Type:")
                    .font(.fontMedium(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
            }
            VStack(alignment: .leading, spacing: 8) {
                Text("\(time, formatter: timeFormatter)")
                    .font(.fontRegular(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
                Text(days.joined(separator: ", "))
                    .font(.fontRegular(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
                Text(type ? "Turn On":"Turn Off")
                    .font(.fontRegular(size: 16))
                    .foregroundColor( on ? .DesignSystem.black : .DesignSystem.darkGrey)
            }
            Spacer()
            Toggle("", isOn: $on)
                .tint(color)
        }
    }
    .padding(12)
    .background(RoundedRectangle(cornerRadius: 12).fill( !on ? Color.DesignSystem.lightGrey : Color.DesignSystem.white))
    .background(Color.DesignSystem.background)
        
    }
    // Formatter to display only the time part
      private var timeFormatter: DateFormatter {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "h:mm a"
          return dateFormatter
      }
}

#Preview {
    TimerView(_timer: Timer(time: Date(), days: ["Monday"], type: true), _color: .blue)
}
