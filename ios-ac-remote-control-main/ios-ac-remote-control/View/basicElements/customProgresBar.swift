
import SwiftUI

struct HalfCircularProgressBar: View {
    @Binding var progress: Float
    var colorBackgound: Color
    var colorForeground: Color
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.15, to: 0.85)
                .stroke(style: StrokeStyle(lineWidth: 14.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(colorBackgound)
                .rotationEffect(.degrees(90))
                .padding(0)
            
            Circle()
                .trim(from: 0.15, to: self.progress < 0.85 ? CGFloat(self.progress) : 0.85)
                .stroke(style: StrokeStyle(lineWidth: 14.0, lineCap: .round, lineJoin: .round))
                .fill(colorForeground)
                .rotationEffect(.degrees(90))
                .padding(0)
        }
        .padding(0)
    }
}
