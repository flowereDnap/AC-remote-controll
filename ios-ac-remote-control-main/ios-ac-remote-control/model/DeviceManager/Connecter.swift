
import Foundation

import SwiftAsyncSocket



//scans local NW for devices checks if their IP changed and connects device manager to device by its ID (cid property)
class Connecter {
    
    // MARK: - Properties
    
    var socket: SwiftAsyncUDPSocket
    var encryptor: Encryptor = Encryptor()
    
    // MARK: - Init
    init(_port: Int = 7000) {
        // you can not set delegate here because in this line that init function has not complete.So set delegate next line
        socket = SwiftAsyncUDPSocket(delegate: nil, delegateQueue: DispatchQueue.main)
        // All the delagate function is optional. If you want to use. You can implement it.
        socket.delegate = self
    }
    
}
/// You don't need implement any method to send data
extension Connecter: SwiftAsyncUDPSocketDelegate {
    
    
    func updSocket(_ socket: SwiftAsyncUDPSocket,
                   didReceive data: Data,
                   from address: SwiftAsyncUDPSocketAddress,
                   withFilterContext filterContext: Any?) {

            handleHandshakeResponse(address: address, responce: data)

    }
    
}

extension Connecter {
    
    func scanAndConnect () {
        do {
            try socket.enableBroadcast(isEnable: true)
            
            let broadcastAddress = "255.255.255.255"
            let port: UInt16 = 7000
            
            let request = Requests.scan()
            let requestData = try parseTo(data: request)
            
            socket.send(
                data: requestData,
                toHost: broadcastAddress,
                port: port,
                timeout: -1,
                tag: 0
            )
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func handleHandshakeResponse(address: SwiftAsyncUDPSocketAddress, responce: Data) {
        do {
            // Connected
            let message  = try parseFrom(data: responce)
            let pack = try encryptor.decode(input: (message["pack"] as? Data)!)
            
            
            if pack["t"] as! String == "dev" {
                guard let targetCid = pack["cid"] as? String ?? pack["mac"] as? String else {
                      // Handle the case where 'a' is nil
                      //TODO
                      return
                  }
                
                //TODO
                /*guard let manager = Model.shared.deviceManagers.first(where: { $0.cid == targetCid }) else {
                      // Handle the case where 'a' is nil
                      print("a is nil")
                      return
                  }
                
                if manager.host != address.host {
                    manager.updHost(_host: address.host)
                }
                 */
            }
        } catch {
            // Here to print error
            //TODO error throw to model
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
    
}

