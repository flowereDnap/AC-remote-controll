import SwiftUI

struct CustomInfoAlert: View {

    // MARK: - Value
    // MARK: Public
    let title: String
    let message: String
    
    @Binding var isPresented: Bool
    
    // MARK: Private
    @State private var opacity: CGFloat           = 0
    @State private var backgroundOpacity: CGFloat = 0.5
    @State private var scale: CGFloat             = 0.001


    // MARK: - View
    // MARK: Public
    var body: some View {
        ZStack {
                    // Dimming background
            Color.gray.opacity(0.5).ignoresSafeArea()
                    
                    // Alert view
                    alertView
                }
                .opacity(isPresented ? 1 : 0) // Show or hide the alert based on isPresented
                .animation(.default)
        }

    // MARK: Private
    private var alertView: some View {
        VStack(spacing: 20) {
            titleView
            Text("errorajsdhlaksd';asld'as;ld lashdlfkjajs'd;lkfasdlfjljsadhflk;asd'fl;kasd;klfjlas;jf")
                .font(.fontRegular(size: 13))
            buttonsView
        }
        .padding(20)
        .frame(width: 320)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.4), radius: 16, x: 0, y: 12)
    }

    @ViewBuilder
    private var titleView: some View {
        if !title.isEmpty {
                Text(title)
                    .font(.fontBold(size: 17))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var buttonsView: some View {
        HStack(spacing: 16) {
            dismissButtonView
        }
    }

    @ViewBuilder
    private var dismissButtonView: some View {
        Button {
            animate(isShown: false) {
                isPresented = false
            }
        } label: {
                Text("Ok")
                .padding()
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(myButtonStyle(type: myBttStylesTypes.usual))
    }

    private var dimView: some View {
        Color.DesignSystem.lightGrey
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

struct DemoView2: View {

    // MARK: - Value
    // MARK: Private
    @State private var isAlertPresented = false
    @State var text = "hiii"

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
                    CustomInfoAlert(title: "Hi", message: "no hi", isPresented: $isAlertPresented)
                )
    }
}

#if DEBUG
struct DemoView_Previews2: PreviewProvider {

    static var previews: some View {
        DemoView2()
            .previewDevice("iPhone 11 Pro")
    }
}
#endif


