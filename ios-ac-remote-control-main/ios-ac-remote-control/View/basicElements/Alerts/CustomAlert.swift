import SwiftUI

struct RoomNameAlert<Content>: View where Content: View {

    // MARK: - Value
    // MARK: Public
    let title: String
    
    @Binding var isValidInput: Bool
    @Binding var isPresented: Bool
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0.5
    @State private var scale: CGFloat             = 0.001

    var okAction: () -> Void

    var containedView: Content
    
    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
                    // Dimming background
            Color.gray.opacity(0.5).ignoresSafeArea()
                    
                    // Alert view
                    alertView
                .padding(.horizontal, 16)
                }
                .opacity(isPresented ? 1 : 0) // Show or hide the alert based on isPresented
                .animation(.default)
        }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            containedView
            buttonsView
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .lineSpacing(24 - UIFont.systemFont(ofSize: 18, weight: .bold).lineHeight)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 16) {
            dismissButtonView
            primaryButtonView
        }
    }

    @ViewBuilder
    private var primaryButtonView: some View {
        
            Button {
                animate(isShown: false) {
                    isPresented = false
                }
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    okAction()
                }
            } label : {
                Text("Ok")
                    .padding()
                    .font(.fontRegular(size: 12))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(myButtonStyle(type: isValidInput ?  .usual : .unavaliable))
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        let title = "Cansel"
        let styleT = myBttStylesTypes.negativeBorderOnly
            Button {
                animate(isShown: false) {
                    isPresented = false
                }
            } label: {
                Text(title)
                .padding()
                .font(.fontRegular(size: 12))
                .frame(maxWidth: .infinity)
        }
            .buttonStyle(myButtonStyle(type: styleT))
    }

    private var dimView: some View {
            Color.clear
                .opacity(0.50)
                .opacity(backgroundOpacity)
    }


    // MARK: - Function
    // MARK: Private
    private func animate(isShown: Bool, completion: (() -> Void)? = nil) {
        switch isShown {
        case true:
            opacity = 1
    
            withAnimation(.spring(response: 0.3, dampingFraction: 0.9, blendDuration: 0).delay(0.5)) {
                backgroundOpacity = 1
                scale             = 1
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?()
            }
    
        case false:
            withAnimation(.easeOut(duration: 0.2)) {
                backgroundOpacity = 0
                opacity           = 0
            }
    
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                completion?()
            }
        }
    }
}

struct DemoView: View {

    // MARK: - Value
    // MARK: Private
    @State private var isAlertPresented = false
    @State var text = ""
    @State var isValidInput = false

    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
            Color.blue
            Button {
                isAlertPresented = true
            } label: {
                Text("Alert test")
                    .padding()
                    .background(.white)
            }
        }
        .overlay(
            RoomNameAlert(title: "New Room Name",
                          isValidInput: $isValidInput,
                          isPresented: $isAlertPresented,
                          okAction: {
                          //TODO
            }, containedView:
                            TextFieldView(text: $text, validInput: $isValidInput, placeholder: "Enter new room name")
                
            )
        )
    }
}

#if DEBUG
struct DemoView_Previews: PreviewProvider {

    static var previews: some View {
        DemoView()
            .previewDevice("iPhone 11 Pro")
    }
}
#endif


