

import Foundation

/// Errors that can occur in the HVAC client.
import Foundation

enum DeviceManagerError: Error {
    case socketSendError(cause: Error)
    case messageSerializationError
    case messageParseError(props: String)
    case decryptError
    case encryptError
    case unknownMessageError(props: [String: Any])
    case notConnectedError
    case connectTimeoutError
    case cancelConnectError
    
}

extension DeviceManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .socketSendError(let cause):
            return cause.localizedDescription
        case .messageParseError( let pack):
            return "Can not parse device JSON response, pack: \(pack)"
        case .decryptError:
            return "Can not decrypt message"
        case .encryptError:
            return "Can not encrypt message"
        case .unknownMessageError:
            return "Unknown message type received"
        case .notConnectedError:
            return "Client is not connected to the HVAC"
        case .connectTimeoutError:
            return "Connecting to HVAC timed out"
        case .cancelConnectError:
            return "Connecting to HVAC was cancelled"
        case .messageSerializationError:
            return "Failed to serialize data"
        }
    }
}
