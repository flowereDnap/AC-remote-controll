
import Foundation

import SwiftAsyncSocket


//TODO throws func error handling

class DeviceManager: Codable {
    
    // MARK: - Properties
    
    var socket: SwiftAsyncUDPSocket
    var cid: String? = nil
    var defaultPropertiesKeys =  [
        "Pow",
        "Mod",
        "SetTem",
        "WdSpd",
        "Air",
        "Blo",
        "Health",
        "SwhSlp",
        "Lig",
        "SwingLfRig",
        "SwUpDn",
        "Quiet",
        "Tur",
        "StHt",
        "TemUn",
        "HeatCoolType",
        "TemRec",
        "SvSt"
      ]
    weak var device: Device?
    var encryptor: Encryptor = Encryptor()
    var timeSync: Bool = false
   
    
    var isConnected: Bool = false
    
    var host: String = "localhost"
    var port: Int = 7000
    var connectTimeout: Int = 3000
    var poll: Bool = false
    var pollingInterval: Int = 3000
    var pollingTimeout: Int = 1000
    
    var curentProperties: [String: CodableValue] = [:]
    
   
    // MARK: - Init
    init(port: Int = 7000) {
        // you can not set delegate here because in this line that init function has not complete.So set delegate next line
        socket = SwiftAsyncUDPSocket(delegate: nil, delegateQueue: DispatchQueue.main)
        // All the delagate function is optional. If you want to use. You can implement it.
        socket.delegate = self
        
        do {
            try socket.connect(to: host, port: UInt16(port))
            try socket.receiveAlways()
            
            let request = Requests.scan()
            send(request: request)
            
        } catch {
            print ("err updating host: \(error)")
        }
    }
    
    init (test: String = "") {
        socket = SwiftAsyncUDPSocket(delegate: nil, delegateQueue: DispatchQueue.main)
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.init(port: 7000)

        cid = try container.decode(String?.self, forKey: .cid)
        encryptor = try container.decode(Encryptor.self, forKey: .encryptor)
        timeSync = try container.decode(Bool.self, forKey: .timeSync)
        isConnected = try container.decode(Bool.self, forKey: .isConnected)
        host = try container.decode(String.self, forKey: .host)
        port = try container.decode(Int.self, forKey: .port)
        connectTimeout = try container.decode(Int.self, forKey: .connectTimeout)
        poll = try container.decode(Bool.self, forKey: .poll)
        pollingInterval = try container.decode(Int.self, forKey: .pollingInterval)
        pollingTimeout = try container.decode(Int.self, forKey: .pollingTimeout)
    }
    
    private enum CodingKeys: String, CodingKey {
        case cid
        case encryptor
        case timeSync
        case isConnected
        case host
        case port
        case connectTimeout
        case poll
        case pollingInterval
        case pollingTimeout
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(cid, forKey: .cid)
        try container.encode(encryptor, forKey: .encryptor)
        try container.encode(timeSync, forKey: .timeSync)
        try container.encode(isConnected, forKey: .isConnected)
        try container.encode(host, forKey: .host)
        try container.encode(port, forKey: .port)
        try container.encode(connectTimeout, forKey: .connectTimeout)
        try container.encode(poll, forKey: .poll)
        try container.encode(pollingInterval, forKey: .pollingInterval)
        try container.encode(pollingTimeout, forKey: .pollingTimeout)
    }
    
    
}
/// You don't need implement any method to send data
extension DeviceManager: SwiftAsyncUDPSocketDelegate {
    
    
    func updSocket( _: SwiftAsyncUDPSocket,
                   didReceive data: Data,
                   from address: SwiftAsyncUDPSocketAddress,
                   withFilterContext filterContext: Any?) {
        if isConnected {
            handleResponse(buffer: data)
        } else {
            handleHandshakeResponse(address: address, responce: data)
        }
    }
    
}

extension DeviceManager {
    
    // MARK: - API functions
    func switchToLocalNW(networkName: String, networkPass: String) {
            let request = Requests.switchToLocalNW(networkName: networkName, networkPass: networkPass)
            send(request: request)
    }
    
    
    private func handleHandshakeResponse(address: SwiftAsyncUDPSocketAddress, responce: Data) {
        do {
            // Connected
            let message  = try parseFrom(data: responce)
            let pack = try encryptor.decode(input: (message["pack"] as? Data)!)
            
            
            if pack["t"] as! String == "dev" {
                    guard let cid = pack["cid"] as? String ?? pack["mac"] as? String else {
                      // Handle the case where 'a' is nil
                      //TODO
                      return
                  }
                    
                    let device = Device(manager: self)
                    device.cid = cid
                    device.version = pack["ver"] as! String
                
                    self.device = device
                    self.cid = cid
                    
                    try socket.connect(to: address.host, port: 7000)
                    try socket.receiveAlways()
                
                    let pack = Requests.bindPack(macAdress: cid)
                    let ecnryptedPack = try encryptor.encode(input: pack)
                    let request = Requests.sendPackRequest(pack: ecnryptedPack, macAdress: cid)
                    send(request: request)
            } else if pack["t"] as! String == "bindok" {
                handleBindingConfirmationResponse(pack: pack)
            }
            
        } catch {
            // Here to print error
            //TODO error throw to model
            print("\(error)")
        }
    }
    
    
    func send(request: [String: Any] ) {
        do {
            let data = try parseTo(data: request)
            socket.send(data: data, timeout: -1, tag: 10)
            // Use next line if you want to receive data
            try socket.receiveAlways()
        } catch {
            print("\(error)")
        }
    }
    
    func parseTo(data: [String: Any]) throws -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            throw DeviceManagerError.messageSerializationError
        }
    }
    
    func parseFrom(data: Data) throws -> [String: Any] {
        let jsonBuffer = String(data: data, encoding: .utf8) ?? ""
        guard let jsonData = jsonBuffer.data(using: .utf8),
              let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
        else {
            throw DeviceManagerError.messageParseError(props: jsonBuffer)
        }
        return jsonObject
    }
    
    func handleResponse(buffer: Data) {
        do {
            
            let message  = try parseFrom(data: buffer)
            let pack = try encryptor.decode(input: (message["pack"] as? Data)!)
            
            if let packType = pack["t"] as? String {
                switch packType {
                case "dat":
                    handleStatusResponse(pack: pack)

                case "res":
                    handleUpdateConfirmResponse(pack: pack)
                default:
                    // Handle other message types if needed
                    break
                }
            } else {
                throw DeviceManagerError.unknownMessageError(props: pack)
            }
        } catch {
            // Handle error
            print("Error handling response: \(error)")
        }
    }
    
    
    func handleBindingConfirmationResponse(pack: [String: Any]) {
        guard let key = pack["key"] as? String else {
            return
        }
        encryptor.key = key
        isConnected = true
        
        do {
            let pack = Requests.getStatusPack(propertiesKeys: defaultPropertiesKeys, macAddress: cid ?? "")
            let ecnryptedPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: ecnryptedPack, macAdress: cid ?? "")
            
            send(request: request)
        } catch {
            print(error)
        }
    }
    
    func handleStatusResponse(pack: [String: Any]) {
        
        var newProperties: [String: CodableValue] = [:]
        
        if let keys = pack["cols"] as? [String], let values = pack["dat"] as? [Any] {
            for (i , key) in keys.enumerated() {
                newProperties[key] = CodableValue(values[i])
            }
        }
        
        device?.properties = newProperties
    }
    
    func handleUpdateConfirmResponse(pack: [String: Any]) {
        if let opt = pack["opt"] as? [String] {
            if let value = pack["val"] as? [Any] ?? pack["p"] as? [Any] {
                for (i, property) in opt.enumerated() {
                    device?.properties[property] = CodableValue(value[i])
                }
            }
            
        }
    }

    
    func setProperties(properties: [String:Any]) {
        do {
            let pack = Requests.setParametersPack(parametersKeys: Array(properties.keys),
                                                  parametersValues: Array(properties.values),
                                                  macAddress: cid!)
            let encPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: encPack, macAdress: cid!)
            send(request: request)
        } catch {
            print("error setting properties \(error)")
        }
    }
    
    func setSchedule (properties: [String:Any],
                      enable: Int,
                      hr: Int,
                      min: Int,
                      name: String,
                      tz: Int,
                      week: [Int]) {
        do {
            let pack = Requests.schedulePack(macAddress: cid!,parametersKeys: Array(properties.keys),
                                             parametersValues: Array(properties.values),
                                             enable: enable, hr: hr, min: min, name: name, tz: tz, week: week)
            
            let encPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: encPack, macAdress: cid!)
            send(request: request)
        } catch {
            print("error scheduling \(error)")
        }
    }
    
    func setTime(time: String) {
        do {
            let pack = Requests.setDeviceTimePack(macAddress: cid!, time: time)
            let encPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: encPack, macAdress: cid!)
            send(request: request)
        } catch {
            print("error requesting properties \(error)")
        }
    }
    
    func getProperties(properties: [String:Any] ){
        do {
            let pack = Requests.getStatusPack(propertiesKeys: Array(properties.keys), macAddress: cid!)
            let encPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: encPack, macAdress: cid!)
            send(request: request)
        } catch {
            print("error requesting properties \(error)")
        }
    }
    
    func getRoomTemperature() {
        do {
            let pack = Requests.getStatusPack(propertiesKeys: ["TemSen"], macAddress: cid!)
            let encPack = try encryptor.encode(input: pack)
            let request = Requests.sendPackRequest(pack: encPack, macAdress: cid!)
            send(request: request)
        } catch {
            print("error requesting properties \(error)")
        }
    }
    
    func updHost(host: String){
        do {
            self.host = host
            
            socket = SwiftAsyncUDPSocket(delegate: nil, delegateQueue: DispatchQueue.main)
            socket.delegate = self
            
            try socket.connect(to: host, port: UInt16(7000))
            try socket.receiveAlways()
        }catch {
            print ("err updating host: \(error)")
        }
    }
    
}


extension DeviceManager: Hashable {
    static func == (lhs: DeviceManager, rhs: DeviceManager) -> Bool {
        return lhs.cid == rhs.cid
    }
    
    func hash(into hasher: inout Hasher) {
           hasher.combine(cid)
       }
}
