

import SwiftUI

struct NewRoomAlertView: View {
    @Binding var result: String
    @Binding var isValidInput: Bool
    
    @State var isTextFieldValid: Bool = false {
        didSet {
            isValidInput = isTextFieldValid
        }
    }
    @State var chosenOption: Int? {
        didSet {
            if let chosenOption = chosenOption {
                result = options[chosenOption]
            } else {
                result = name
            }
        }
    }
    @State var name: String = ""
    @State var options: [String] = ["BB Room", "Dining Room", "Cloakroom", "Guest Room"]
    
    init(result: Binding<String>, isValidInput: Binding<Bool>) {
        _result = result
        _isValidInput = isValidInput
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Enter your new room name")
                .font(.fontRegular(size: 16))
                
            
            TextFieldView(text: $name, validInput: $isValidInput, placeholder: "Enter new room name")
                .font(.fontRegular(size: 16))
                
            
            HStack {
                Spacer()
                Text("or")
                    .font(.fontRegular(size: 16))
                    
                Spacer()
            }
            .padding()
            
            Text("Choose from the following options")
                .font(.fontRegular(size: 16))
                
            
            ForEach($options, id: \.self) { option in
                if let index = options.firstIndex(of: option.wrappedValue) {
                    Button {
                        if chosenOption != index {
                            chosenOption = index
                            isValidInput = true
                        } else {
                            chosenOption = nil
                            isValidInput = isTextFieldValid
                        }
                    } label : {
                        
                        Text(options[index])
                            .font(.fontRegular(size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(myButtonStyle(type: chosenOption != index ? .usualBorderOnly : .usual ))
                    .animation(.default)
                    
                }
            }
            
        }
    }
}

struct NewRoomAlertView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        @State var name: String = ""
        @State var isValid: Bool = false
        
        NewRoomAlertView(result: $name, isValidInput: $isValid)
    }
}
