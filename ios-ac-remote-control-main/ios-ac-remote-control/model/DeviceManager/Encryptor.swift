import Foundation
import CommonCrypto

class Encryptor: Codable {
    private var keyData: Data

    init(key: String = "a3K8Bx%2r8Y7#xDh") {
        // Convert the key string to Data
        guard let keyData = key.data(using: .utf8) else {
            fatalError("Failed to convert key to Data")
        }
        self.keyData = keyData
    }
    
    var key: String {
        get {
            // Convert Data to a UTF-8 encoded string
            return String(data: keyData, encoding: .utf8) ?? ""
        }
        set {
            // Convert the string to Data
            if let newKeyData = newValue.data(using: .utf8) {
                keyData = newKeyData
            } else {
                // Handle invalid string, maybe throw an error or log a message
                print("Failed to convert string to Data")
            }
        }
    }

    func encode(input: [String: Any]) throws -> Data {
        do {
            // Convert the [String: Any] input to Data
            let jsonData = try JSONSerialization.data(withJSONObject: input, options: [])
            
            // Base64 encode the data
            let base64EncodedData = jsonData.base64EncodedData()

            // Perform AES encryption on the base64-encoded data
            let bufferSize = base64EncodedData.count + kCCBlockSizeAES128
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            var numBytesProcessed: size_t = 0

            let status = keyData.withUnsafeBytes { keyBytes in
                return base64EncodedData.withUnsafeBytes { dataBytes in
                    return CCCrypt(
                        CCOperation(kCCEncrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES128,
                        nil,
                        dataBytes.baseAddress, base64EncodedData.count,
                        &buffer,
                        bufferSize,
                        &numBytesProcessed
                    )
                }
            }

            guard status == kCCSuccess else {
                throw NSError(domain: "CCCrypt", code: Int(status))
            }

            // Convert the processed buffer to Data
            return Data(buffer.prefix(upTo: numBytesProcessed))
        } catch {
            throw NSError(domain: "SerializationError", code: 0, userInfo: nil)
        }
    }

    func decode(input: Data) throws -> [String: Any] {
        do {
            // Perform AES decryption on the input data
            let bufferSize = input.count + kCCBlockSizeAES128
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            var numBytesProcessed: size_t = 0

            let status = keyData.withUnsafeBytes { keyBytes in
                return input.withUnsafeBytes { dataBytes in
                    return CCCrypt(
                        CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES),
                        CCOptions(kCCOptionPKCS7Padding),
                        keyBytes.baseAddress, kCCKeySizeAES128,
                        nil,
                        dataBytes.baseAddress, input.count,
                        &buffer,
                        bufferSize,
                        &numBytesProcessed
                    )
                }
            }

            guard status == kCCSuccess else {
                throw NSError(domain: "CCCrypt", code: Int(status))
            }

            // Convert the processed buffer to Data
            let processedData = Data(buffer.prefix(upTo: numBytesProcessed))

            // Base64 decode the processed data to 'utf8'
            if let decodedData = Data(base64Encoded: processedData),
               let decodedObject = try JSONSerialization.jsonObject(with: decodedData, options: []) as? [String: Any] {
                return decodedObject
            } else {
                throw NSError(domain: "DecodingError", code: 0, userInfo: nil)
            }
        } catch {
            throw NSError(domain: "DecryptionError", code: 0, userInfo: nil)
        }
    }

}

