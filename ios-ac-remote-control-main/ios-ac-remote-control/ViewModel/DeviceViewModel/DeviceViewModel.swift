import Foundation
import SwiftUI
import Combine

class DeviceViewModel: ObservableObject, Identifiable, Equatable, Hashable {
    static func == (lhs: DeviceViewModel, rhs: DeviceViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var properties: [String: CodableValue]
    
    var id: String = UUID().uuidString
    
    var device: Device?
    weak var room: RoomViewModel?
    
 
        
    
    var options: [Property<Bool>] = []
    
    var name: String
    
    var subscription: AnyCancellable? = nil
    
    @Published var power: Property<Bool> = Property(type: .power, value: false, isChangeble: false, updateBehavior: {})
    @Published var mode: Property<String> = Property(type: .mode, value: "Auto", isChangeble: false, updateBehavior: {})
    @Published var light: Property<Bool> = Property(type: .light, value: false, isChangeble: false, updateBehavior: {})
    @Published var xFan: Property<Bool> = Property(type: .XFan, value: false, isChangeble: false, updateBehavior: {})
    @Published var health: Property<Bool> = Property(type: .Health, value: false, isChangeble: false, updateBehavior: {})
    @Published var heating: Property<Bool> = Property(type: .Heating, value: false, isChangeble: false, updateBehavior: {})
    @Published var se: Property<Bool> = Property(type: .SE, value: false, isChangeble: false, updateBehavior: {})
    @Published var sleep: Property<Bool> = Property(type: .Sleep, value: false, isChangeble: false, updateBehavior: {})
    @Published var fanSpeed: Property<Int> = Property(type: .fanSpeed, value: 0, isChangeble: false, updateBehavior: {})
    @Published var temperature: Property<Double> = Property(type: .temperature, value: 0, isChangeble: false, updateBehavior: {})
    @Published var isFahrenheit: Property<Bool> = Property(type: .isFahrenheit, value: false, isChangeble: false, updateBehavior: {})
    @Published var swingHorizontal: Property<Int> = Property(type: .swingHorizontal, value: 0, isChangeble: false, updateBehavior: {})
    @Published var swingVertical: Property<Int> = Property(type: .swingVertical, value: 0, isChangeble: false, updateBehavior: {})
    @Published var quite: Property<Bool> = Property(type: .Quite, value: false, isChangeble: false, updateBehavior: {})
    @Published var turbo: Property<Bool> = Property(type: .Turbo, value: false, isChangeble: false, updateBehavior: {})
    @Published var auto: Property<Bool> = Property(type: .Auto, value: false, isChangeble: false, updateBehavior: {})
    
    
    var timers: [Timer] = []
    
    
    
    
    
    
    init(properties: [String: CodableValue], name: String = "default name") {
        self.properties = properties
        self.name = name
        var publishers: [ObservableObjectPublisher] = []
        
        for optionType in PropertyType.allCases {
            guard let codableValue = properties[optionType.key] else {
                continue
            }
            
            switch optionType {
            case .power:
                power = Property<Bool>(type: optionType, value: codableValue.value as! Int == 0, updateBehavior: updateBehaviorPower)
                publishers.append(power.objectWillChange)
            case .mode:
                switch codableValue.value as! Int {
                case 0:
                    mode = Property<String>(type: optionType, value: "Auto", updateBehavior: updateBehaviorMode)
                case 1:
                    mode = Property<String>(type: optionType, value: "Cool", updateBehavior: updateBehaviorMode)
                case 2:
                    mode = Property<String>(type: optionType, value: "Dry", updateBehavior: updateBehaviorMode)
                case 3:
                    mode = Property<String>(type: optionType, value: "Fan", updateBehavior: updateBehaviorMode)
                case 4:
                    mode = Property<String>(type: optionType, value: "Heat", updateBehavior: updateBehaviorMode)
                default:
                    mode = Property<String>(type: optionType, value: "Auto", updateBehavior: updateBehaviorMode)
                }
                publishers.append(mode.objectWillChange)
            case .light:
                light = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorLight)
                publishers.append(light.objectWillChange)
                options.append(light)
            case .XFan:
                xFan = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorXFan)
                publishers.append(xFan.objectWillChange)
                options.append(xFan)
            case .Health:
                health = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorHealth)
                publishers.append(health.objectWillChange)
                options.append(health)
            case .Heating:
                heating = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorHeating)
                publishers.append(heating.objectWillChange)
                options.append(heating)
            case .SE:
                se = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorSe)
                publishers.append(se.objectWillChange)
                options.append(se)
            case .Sleep:
                sleep = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorSleep)
                publishers.append(sleep.objectWillChange)
                options.append(sleep)
            case .fanSpeed:
                fanSpeed = Property<Int>(type: optionType, value: codableValue.value as! Int, updateBehavior: updateBehaviorFanSpeed)
                publishers.append(fanSpeed.objectWillChange)
            case .temperature:
                temperature = Property<Double>(type: optionType, value: codableValue.value as! Double, updateBehavior: updateBehaviorTemperature)
                publishers.append(temperature.objectWillChange)
            case .isFahrenheit:
                isFahrenheit = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorIsFahrenheit)
                publishers.append(isFahrenheit.objectWillChange)
            case .swingHorizontal:
                swingHorizontal = Property<Int>(type: optionType, value: codableValue.value as! Int, updateBehavior: updateBehaviorSwingHorizontal)
                publishers.append(swingHorizontal.objectWillChange)
            case .swingVertical:
                swingVertical = Property<Int>(type: optionType, value: codableValue.value as! Int, updateBehavior: updateBehaviorSwingVertical)
                publishers.append(swingVertical.objectWillChange)
            case .Quite:
                quite = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorQuite)
                publishers.append(quite.objectWillChange)
            case .Turbo:
                turbo = Property<Bool>(type: optionType, value: codableValue.value as! Int == 1, updateBehavior: updateBehaviorTurbo)
                publishers.append(turbo.objectWillChange)
            case .Auto:
                auto = Property<Bool>(type: optionType, value: codableValue.value as! Int == 0, updateBehavior: updateBehaviorQuite)
                publishers.append(turbo.objectWillChange)
            }
        }
        
        let mergedPublisher = Publishers.MergeMany(publishers)
        subscription = mergedPublisher.sink { [weak self] (_) in
            self?.objectWillChange.send()
            
        }
    }



    
    /*init(Device: Device, options: [String : Bool]) {
     self.Device = Device
     
     //load all options
     for optionType in OptionType.allCases {
     guard let codableValue = Device.properties[optionType.rawValue] else {
     let option = Option(type: optionType, value: nil, options: self.options)
     self.options.append(option)
     
     continue
     }
     
     let option = Option(type: optionType, value: codableValue.value, options: self.options )
     
     self.options.append(option)
     }
     
     //setup states up to options values
     for option in self.options {
     option.notifyObservers()
     }
     }*/
    
    var colors: (main: Color, secondary: Color) {
        switch mode.value {
        case "Auto":
            return (.DesignSystem.black , .DesignSystem.lightGrey)
        case "Cool":
            return (.DesignSystem.blue , .DesignSystem.extraLightBlue)
        case "Dry":
            return (.DesignSystem.green , .DesignSystem.lightGreen)
        case "Fan":
            return (.DesignSystem.violet , .DesignSystem.violet2)
        case "Heat":
            return (.DesignSystem.red , .DesignSystem.olive)
        default:
            return (.DesignSystem.black , .DesignSystem.lightGrey)
        }
    }
    
    func copyWithSameManager() -> DeviceViewModel {
        let newDevice = device?.copyWithSameManager()
        let newVM = DeviceViewModel(properties: self.properties)
        newVM.device = newDevice
        return newVM
        
    }
    
    static let deviceViewModel = DeviceViewModel (properties: deviceProperties1)
    static let deviceViewModels = [DeviceViewModel (properties: deviceProperties1),
                                   DeviceViewModel (properties: deviceProperties2),
                                   DeviceViewModel (properties: deviceProperties3),
                                   DeviceViewModel (properties: deviceProperties4)]
    
    static let deviceProperties1: [String: CodableValue] = [
        "Pow": CodableValue(0),
        "Mod": CodableValue(0),
        "Lig": CodableValue(0),
        "Blo": CodableValue(0),
        "Health": CodableValue(0),
        "StHt": CodableValue(0),
        "SE": CodableValue( 0),
        "SwhSlp": CodableValue( 0),
        "WdSpd": CodableValue( 0),
        "SetTem": CodableValue( 20.0),
        "TemUn": CodableValue( 0),
        "SwingLfRig": CodableValue( 0),
        "SwUpDn": CodableValue( 0),
        "Quite": CodableValue( 0),
        "Tur": CodableValue( 0),
    ]
    
    
    static let deviceProperties2: [String: CodableValue] = [
        "Pow": CodableValue(0),
        "Mod": CodableValue(3),
        "Lig": CodableValue(0),
        "Blo": CodableValue(1),
        "Health": CodableValue(0),
        "StHt": CodableValue(0),
        "SE": CodableValue( 0),
        "SwhSlp": CodableValue( 0),
        "WdSpd": CodableValue( 0),
        "SetTem": CodableValue( 20.0),
        "TemUn": CodableValue( 0),
        "SwingLfRig": CodableValue( 0),
        "SwUpDn": CodableValue( 0),
        "Quite": CodableValue( 0),
        "Tur": CodableValue( 0),
    ]
    
    static let deviceProperties3: [String: CodableValue] = [
        "Pow": CodableValue(0),
        "Mod": CodableValue(4),
        "Lig": CodableValue(0),
        "Blo": CodableValue(1),
        "Health": CodableValue(0),
        "StHt": CodableValue(0),
        "SE": CodableValue( 0),
        "SwhSlp": CodableValue( 0),
        "WdSpd": CodableValue( 0),
        "SetTem": CodableValue( 30.0),
        "TemUn": CodableValue( 0),
        "SwingLfRig": CodableValue( 0),
        "SwUpDn": CodableValue( 0),
        "Quite": CodableValue( 0),
        "Tur": CodableValue( 0),
    ]
    
    static let deviceProperties4: [String: CodableValue] = [
        "Pow": CodableValue(0),
        "Mod": CodableValue(2),
        "Lig": CodableValue(0),
        "Blo": CodableValue(1),
        "Health": CodableValue(0),
        "StHt": CodableValue(0),
        "SE": CodableValue( 0),
        "SwhSlp": CodableValue( 0),
        "WdSpd": CodableValue( 0),
        "SetTem": CodableValue( 55.0),
        "TemUn": CodableValue( 0),
        "SwingLfRig": CodableValue( 0),
        "SwUpDn": CodableValue( 0),
        "Quite": CodableValue( 0),
        "Tur": CodableValue( 0),
    ]
    
    static let def: [String: CodableValue] = [
        "Pow": CodableValue(0),
        "Mod": CodableValue(0),
        "Lig": CodableValue(0),
        "Blo": CodableValue(0),
        "Health": CodableValue(0),
        "StHt": CodableValue(0),
        "SE": CodableValue( 0),
        "SwhSlp": CodableValue( 0),
        "WdSpd": CodableValue( 0),
        "SetTem": CodableValue( 20.0),
        "TemUn": CodableValue( 0),
        "SwingLfRig": CodableValue( 0),
        "SwUpDn": CodableValue( 0),
        "Quite": CodableValue( 0),
        "Tur": CodableValue( 0),
    ]
    
    
}

extension DeviceViewModel{
    
    
    // Update behavior for the mode property
    func updateBehaviorMode() {
        // Implement behavior update for the mode property here
        
        xFan.isChangeble = (mode.value == "Cool" || mode.value == "Dry")
        heating.isChangeble = (mode.value == "Heat")
        se.isChangeble = (mode.value == "Cool")
        sleep.isChangeble = (mode.value == "Cool" || mode.value == "Heat")
        fanSpeed.isChangeble = (mode.value == "Dry")
        if mode.value == "Dry" {
            fanSpeed.value = 0
        }
        temperature.isChangeble = (mode.value == "Auto")
        quite.isChangeble = (mode.value == "Cool" || mode.value == "Heat")
        turbo.isChangeble = (mode.value == "Cool" || mode.value == "Heat")
    }
    
    // Update behavior for the heating property
    func updateBehaviorHeating() {
        // Implement behavior update for the heating property here
        sleep.isChangeble = !heating.value
        fanSpeed.isChangeble = !heating.value
        temperature.isChangeble = !heating.value
        quite.isChangeble = !heating.value
        turbo.isChangeble = !heating.value
    }
    
    // Update behavior for the se property
    func updateBehaviorSe() {
        // Implement behavior update for the se property here
        sleep.isChangeble = !se.value
        fanSpeed.isChangeble = !se.value
        temperature.isChangeble = !se.value
        quite.isChangeble = !se.value
        turbo.isChangeble = !se.value
    }
    
    // Update behavior for the sleep property
    func updateBehaviorSleep() {
        // Implement behavior update for the sleep property here
        heating.isChangeble = !sleep.value
        se.isChangeble = !sleep.value
        
    }
    
    // Update behavior for the fanSpeed property
    func updateBehaviorFanSpeed() {
        // Implement behavior update for the fanSpeed property here
        quite.value = false
        turbo.value = false
    }
    
   
    
    // Update behavior for the quite property
    func updateBehaviorQuite() {
        // Implement behavior update for the quite property here
        fanSpeed.isChangeble = !quite.value
    }
    
    // Update behavior for the turbo property
    func updateBehaviorTurbo() {
        // Implement behavior update for the turbo property here
        fanSpeed.isChangeble = !turbo.value
    }
    
    // Update behavior for the auto property
    func updateBehaviorAuto() {
        // Implement behavior update for the auto property here
        fanSpeed.isChangeble = !auto.value
    }
    
    
    // Update behavior for the power property
    func updateBehaviorPower() {
        // Implement behavior update for the power property here
    }
    
    
    
    // Update behavior for the light property
    func updateBehaviorLight() {
        // Implement behavior update for the light property here
    }
    
    // Update behavior for the xFan property
    func updateBehaviorXFan() {
        // Implement behavior update for the xFan property here
    }
    
    // Update behavior for the health property
    func updateBehaviorHealth() {
        // Implement behavior update for the health property here
    }
    
    // Update behavior for the temperature property
    func updateBehaviorTemperature() {
        // Implement behavior update for the temperature property here
        let min = isFahrenheit.value ? 68.0 : 20.0
        let max = isFahrenheit.value ? 86.0 : 30.0
        if temperature.value < min {
            temperature.value = min
        }
        if temperature.value > max {
            temperature.value = max
        }
        
    }
    
    // Update behavior for the isFahrenheit property
    func updateBehaviorIsFahrenheit() {
        // Implement behavior update for the isFahrenheit property here
        if isFahrenheit.value == true {
            temperature.value = castToFahrenheit(temperature.value)
        } else {
            temperature.value = castFromFahrenheit(temperature.value)
        }
    }
    
    // Update behavior for the swingHorizontal property
    func updateBehaviorSwingHorizontal() {
        // Implement behavior update for the swingHorizontal property here
    }
    
    // Update behavior for the swingVertical property
    func updateBehaviorSwingVertical() {
        // Implement behavior update for the swingVertical property here
    }
    
   
    
    func castToFahrenheit(_ temp: Double) -> Double {
        return temp * 9/5 + 32
    }
    
    func castFromFahrenheit(_ temp: Double) -> Double {
        return (temp - 32) * 5 / 9
    }
}


