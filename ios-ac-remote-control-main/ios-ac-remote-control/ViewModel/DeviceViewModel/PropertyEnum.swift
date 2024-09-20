import Foundation

enum PropertyType: CaseIterable {
    case power
    case mode
    case light
    case XFan
    case Health
    case Heating
    case SE
    case Sleep
    case fanSpeed
    case temperature
    case isFahrenheit
    case swingHorizontal
    case swingVertical
    case Quite
    case Turbo
    case Auto
    
    var key: String {
        switch self {
        case .power:
            return "Pow"
            
        case .mode:
            return "Mod"
            
        case .light:
            return "Lig"
            
        case .XFan:
            return "Blo"
            
        case .Health:
            return "Health"
            
        case .Heating:
            return "StHt"
            
        case .SE:
            return "SE"
            
        case .Sleep:
            return "SwhSlp"
            
        case .fanSpeed:
            return "WdSpd"
            
        case .temperature:
            return "SetTem"
            
        case .isFahrenheit:
            return "TemUn"
            
        case .swingHorizontal:
            return "SwingLfRig"
            
        case .swingVertical:
            return "SwUpDn"
            
        case .Quite:
            return "Quite"
            
        case .Turbo:
            return "Tur"
            
        case .Auto:
            return "WdSpd"
            
        }
    }
    
    var name: String {
        switch self {
        case .light:
            "Light"
        case .mode:
            "Mode"
        case .XFan:
            "X-Fan"
        case .Health:
            "Health"
        case .Heating:
            "Heating"
        case .SE:
            "SE"
        case .Sleep:
            "Sleep"
        case .Quite:
            "Quite"
        case .Turbo:
            "Turbo"
        default:
            ""
        }
    }
}



extension PropertyType {
    func getIcon(value: Any) -> String {
        switch self {
        case .power:
            return ""
        case .mode:
            return Modes.getIcon(value as? Int ?? 0)
        case .light:
            return "icon_bulb_"
        case .XFan:
            return "icon_ripple_"
        case .Health:
            return "icon_christmas_tree_"
        case .Heating:
            return "icon_home_"
        case .SE:
            return "icon_plant_"
        case .Sleep:
            return "icon_moon_"
        case .fanSpeed:
            return "icon_propeller_"
        case .temperature:
            return "icon_bulb_"
        case .isFahrenheit:
            return value as? Bool ?? true ? "icon_fahrenheit_" : "icon_celsius_"
        case .swingHorizontal:
            return "" //TODO
        case .swingVertical:
            return ""
        case .Quite:
            return ""
        case .Turbo:
            return ""
        case .Auto:
            return "icon_auto_"
        }
    }
}

enum Modes : Int, CaseIterable {
    case Auto = 0
    case Cool
    case Dry
    case Fan
    case Heat
    
    var name: String {
        switch self {
        case .Auto:
            return "Auto"
        case .Cool:
            return "Cool"
        case .Dry:
            return "Dry"
        case .Fan:
            return "Fan"
        case .Heat:
            return "Heat"
        }
    }
}

extension Modes {
    static func getIcon(_ value: Int) -> String{
        switch value {
        case 0:
            return "icon_auto_"
        case 1:
            return "icon_snowflake_"
        case 2:
            return "icon_spiral_"
        case 3:
            return "icon_windmill_"
        case 4:
            return "icon_sun_"
        default:
            return ""
        }
    }
}

