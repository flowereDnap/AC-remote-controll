import Foundation

struct CodableValue: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let encodable as Encodable:
            try encodable.encode(to: encoder)
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Value not encodable"))
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intVal = try? container.decode(Int.self) {
            value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            value = doubleVal
        } else if let stringVal = try? container.decode(String.self) {
            value = stringVal
        } else if let boolVal = try? container.decode(Bool.self) {
            value = boolVal
        } else {
            throw DecodingError.typeMismatch(Any.self, DecodingError.Context(codingPath: [], debugDescription: "Unknown type"))
        }
    }
}

extension CodableValue: Equatable {
    static func == (lhs: CodableValue, rhs: CodableValue) -> Bool {
        switch (lhs.value, rhs.value) {
        case (let left as Int, let right as Int):
            return left == right
        case (let left as Double, let right as Double):
            return left == right
        case (let left as String, let right as String):
            return left == right
        case (let left as Bool, let right as Bool):
            return left == right
        default:
            return false
        }
    }
}
