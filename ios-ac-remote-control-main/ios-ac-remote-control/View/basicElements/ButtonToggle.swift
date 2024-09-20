
import SwiftUI


struct CustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var onText: String = "On"
    var offText: String = "Off"
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 8)
                .fill(configuration.isOn ? onColor : offColor)
                .frame(width: 50, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .overlay(
                    Text(configuration.isOn ? "On" : "Off")
                        .foregroundColor(configuration.isOn ? .white : .black)
                )
        }
    }
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    var onColor: Color
    var offColor: Color
    var onText: String = "On"
    var offText: String = "Off"
    
    var body: some View {
        Text("Hi")
    }
}

struct ContentViewToggle: View {
    @State private var isOn = false
    
    var body: some View {
        VStack {
            CustomToggle(isOn: $isOn, onColor: .green, offColor: .red, onText: "Mon", offText: "Mon")
                
            Text(isOn ? "On" : "Off")
        }
        .padding()
    }
}

struct ContentViewToggle_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ContentViewToggle()
    }
}
