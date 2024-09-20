import SwiftUI
import Combine

enum CustomTextViewState: String {
    case notEditingEmpty
    case editing
    case notEditingBadInput
    case notEditingGoodInput
}

struct TextFieldView: View {
    @Binding var text: String
    @Binding var validInput: Bool
    var placeholder: String

    @State private var isEditing: Bool = false
    @State private var currentState: CustomTextViewState = .notEditingEmpty
    @State private var isFilled:Bool = false
    
    @State private var height: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .foregroundColor(text.isEmpty ? Color(.placeholderText) : .accentColor)
                .offset(x: (!isEditing && !isFilled) ? 0 : -16, y: (!isEditing && !isFilled) ? 0 : -height * 0.85)
                .padding()
                .font(.fontRegular(size: (isEditing && isFilled) ? 12 : 16))
            
            TextField(placeholder, text: $text, onEditingChanged: { editing in
                self.isEditing = editing
                self.updateState()
            })
            .padding(.horizontal, 8)
            .frame(height: 48)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .circular))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(strokeColor, lineWidth: 1)
            )
        }
    }

   

    private func updateState() {
        if isEditing {
            currentState = .editing
        } else if text.isEmpty {
            currentState = .notEditingEmpty
            validInput = false
        } else if text.isValidText() {
            currentState = .notEditingBadInput
            validInput = false
        } else {
            currentState = .notEditingGoodInput
            validInput = true
        }
    }

    private var backgroundView: some View {
        switch currentState {
        case .notEditingEmpty, .editing:
            return Color.white
        case .notEditingBadInput:
            return Color.white
        case .notEditingGoodInput:
            return Color.blue.opacity(0.1)
        }
    }

    private var strokeColor: Color {
        switch currentState {
        case .notEditingEmpty:
            return Color.black
        case .editing:
            return Color.blue
        case .notEditingBadInput:
            return Color.red
        case .notEditingGoodInput:
            return Color.clear
        }
    }
}

struct ContentView2222: View {
    @State private var bool: Bool = false
    @State private var text: String = ""

    var body: some View {
        TextFieldView(text: $text, validInput: $bool, placeholder: "Enter room name")
            .padding()
    }
}

struct ContentView_Previews123: PreviewProvider {
    static var previews: some View {
        ContentView2222()
    }
}

