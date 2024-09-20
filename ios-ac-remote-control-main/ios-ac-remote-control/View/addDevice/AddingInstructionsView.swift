import SwiftUI

struct AddingInstructionsView: View {
    @Environment(\.dismiss) private var dismiss
        
    var type: String = "AC"
    
    var body: some View {
        ACConnectionView()
    }
}

struct AddingInstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        AddingInstructionsView()
            .environmentObject(HomeViewModel.viewModel)
    }
}
