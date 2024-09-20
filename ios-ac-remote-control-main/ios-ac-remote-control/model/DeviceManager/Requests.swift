
import Foundation

class Requests {
    
    static func switchToLocalNW(networkName: String, networkPass: String) -> [String: Any] {
        return ["psw": "\(networkPass)",
                "ssid": "\(networkName)",
                "t": "wlan"]
    }
    static func scan () -> [String: Any]  {
        return ["t":"scan"]
    }
    
    static func bindPack(macAdress: String) -> [String: Any] {
       return [
          "mac": macAdress,
          "t": "bind",
          "uid": 0
        ]
    }
    
    static func sendPackRequest(pack: Data, macAdress: String) -> [String: Any]  {
        return [
            "cid": "app",
            "i": 0,
            "pack": pack,
            "t": "pack",
            "tcid": macAdress,
            "uid": 0
          ]
    }
    
    // getStatusPack function
    static func getStatusPack(propertiesKeys: [String], macAddress: String) -> [String: Any] {
        return [
            "cols": [
                propertiesKeys
            ],
            "mac": macAddress,
            "t": "status"
        ]
    }
    
    
    // setParametersPack function
    static func setParametersPack(parametersKeys: [String], parametersValues: [Any], macAddress: String) -> [String: Any] {
        return [
            "opt": parametersKeys,
            "p": parametersValues,
            "t": "cmd"
        ]
    }

    // schedule function
    static func schedulePack(macAddress: String,
                         parametersKeys: [String], parametersValues: [Any],
                         enable: Int,
                         hr: Int,
                         min: Int,
                         name: String,
                         tz: Int,
                         week: [Int]) -> [String: Any] {
        return [
            "cmd": [
                [
                    "mac": [macAddress],
                    "opt": parametersKeys,
                    "p": parametersValues
                ]
            ],
            "enable": enable,
            "hr": hr,
            "id": 0,
            "min": min,
            "name": name,
            "sec": 0,
            "t": "setT",
            "tz": tz,
            "week": week
        ]
    }

    // getDeviceTime function
    static func getDeviceTimePack(macAddress: String) -> [String: Any] {
        return [
            "cols": ["time"],
            "mac": macAddress,
            "t": "status"
        ]
    }

    // setDeviceTime function
    static func setDeviceTimePack(macAddress: String, time: String) -> [String: Any] {
        return [
            "opt": ["time"],
            "p": [time],
            "sub": macAddress,
            "t": "cmd"
        ]
    }

}
