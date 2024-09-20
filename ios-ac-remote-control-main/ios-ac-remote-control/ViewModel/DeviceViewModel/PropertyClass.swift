import Foundation

class Property<T>: ObservableObject {
    
    var type: PropertyType
    
    var name: String {
        return type.name
    }
    var updateBehavior: () -> Void
    
    @Published var value: T {
        didSet {
            updateBehavior()
        }
    }
    
    var icon: String {
        return type.getIcon(value: value)
    }
    
    @Published var isChangeble: Bool
    
    init(type: PropertyType, value: T, isChangeble: Bool = true, updateBehavior: @escaping ()->Void ) {
        self.type = type
        self.value = value
        self.isChangeble = isChangeble
        self.updateBehavior = updateBehavior
        
       
    }
}
