import SwiftUI

enum myBttStylesTypes {
    case usual
    case usualBorderOnly
    case negative
    case negativeBorderOnly
    case unavaliable
}

struct myButtonStyle: ButtonStyle {
    let type: myBttStylesTypes
    var color: Color = .DesignSystem.blue
    var secondaryColor: Color = .DesignSystem.skyBlue
    
    func makeBody(configuration: Configuration) -> some View {
        
        switch type {
        case .usual:
            configuration.label
                .disabled(false)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        case .usualBorderOnly:
            configuration.label
                .disabled(false)
                .foregroundColor(configuration.isPressed ? secondaryColor : color)
                .background( Color.DesignSystem.white)
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(configuration.isPressed ? secondaryColor : color, lineWidth: 1)
                        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                )
        case .negative:
            configuration.label
                .disabled(false)
                .foregroundColor(.white)
                .background(Color.DesignSystem.red)
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        case .negativeBorderOnly:
            configuration.label
                .disabled(false)
                .foregroundColor(configuration.isPressed ? Color.DesignSystem.olive : Color.DesignSystem.red)
                .background( Color.DesignSystem.white)
                .cornerRadius(12)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(configuration.isPressed ? Color.DesignSystem.olive : Color.DesignSystem.red, lineWidth: 1)
                        .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                )
        case .unavaliable:
            configuration.label
                .disabled(true)
                .foregroundColor(Color.DesignSystem.darkGrey)
                .background( Color.DesignSystem.lightGrey)
                .cornerRadius(12)
        }
    }
}
