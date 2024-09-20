
import SwiftUI

struct LoadingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack{
            Color.DesignSystem.lightGrey.opacity(0.5)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ProgressView()
                .frame(width: 30, height: 30)
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.DesignSystem.white))
                
        }
        .opacity(isPresented ? 1 : 0)
    }
}

#Preview {
    @State var b = false
    return LoadingView(isPresented: $b)
}
