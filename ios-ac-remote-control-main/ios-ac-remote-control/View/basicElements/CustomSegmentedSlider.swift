import SwiftUI




public struct segmentedSlider<T, Content> : View where T: Hashable, Content: View {
    @Namespace private var ns
    
    public let sources: [T]
    public let selection: T?
    public let cornerRadius: Double
    private let itemBuilder: (T) -> Content
    private var customIndicator: AnyView? = nil
    
    public init(
    _ sources: [T],
    selection: T?,
    indicatorBuilder: @escaping () -> some View,
    cornerRadius: Double = 12.0,
       @ViewBuilder itemBuilder: @escaping (T) -> Content
    ) {
       self.sources = sources
       self.selection = selection
       self.itemBuilder = itemBuilder
       self.cornerRadius = cornerRadius
       self.customIndicator = AnyView(indicatorBuilder())
    }
    
    public init(
    _ sources: [T],
    selection: T?,
    cornerRadius: Double = 12.0,
       @ViewBuilder itemBuilder: @escaping (T) -> Content
    ) {
       self.sources = sources
       self.selection = selection
       self.cornerRadius = cornerRadius
       self.itemBuilder = itemBuilder
    }
    
    @State private var borderColor: Color?
    func borderColor(_ borderColor: Color) -> segmentedSlider {
    var view = self
       view._borderColor = State(initialValue: borderColor)
    return view
    }
    
    @State private var borderWidth: CGFloat?
    func borderWidth(_ borderWidth: CGFloat) -> segmentedSlider {
    var view = self
       view._borderWidth = State(initialValue: borderWidth)
    return view
    }
    
    public var body: some View {
           HStack(spacing: 0) {
               ForEach(sources, id: \.self) { item in
                   itemBuilder(item)
                       .padding(.vertical, 8)
                       .matchedGeometryEffect(id: item, in: ns, isSource: true)
               }
           }
           .background {
               if let selection = selection, let selectedIdx = sources.firstIndex(of: selection) {
                   if let customIndicator = customIndicator {
                       customIndicator
                           .matchedGeometryEffect(id: selection, in: ns, isSource: false)
                   } else {
                       RoundedRectangle(cornerRadius: cornerRadius)
                           .foregroundColor(.accentColor)
                           .padding(2)
                           .animation(.spring().speed(1.5), value: selection)
                           .matchedGeometryEffect(id: selection, in: ns, isSource: false)
                   }
               }
           }
           .background(
               RoundedRectangle(cornerRadius: cornerRadius)
                   .fill(
                       Color.DesignSystem.white,
                       strokeBorder: borderColor ?? Color.clear,
                       lineWidth: borderWidth ?? .zero
                   )
           )
       }
    
   
}

struct PreviewPickerPlus: View {
    @State private var selectedItem : String? = "Modes"
    @State var selectedSection: SelectedSection = .Mode
    var body: some View {
        VStack {
            segmentedSlider(
                           ["Modes","Wind Power", "Timer"],
            selection: selectedItem
                       ) { item in
            Text(item.capitalized)
                               .font(Font.footnote.weight(.medium))
                               .foregroundColor(selectedItem == item ? .white : .black)
                               .padding(.horizontal, 0)
                               .padding(.vertical, 0)
                               .frame(maxWidth: .infinity)
                               .multilineTextAlignment(.center)
                               .contentShape(Rectangle())
                               .onTapGesture {
            withAnimation(.easeInOut(duration: 0.150)) {
                                       selectedItem = item
                                   }
                               }
                       }
                       .borderColor(.blue)
                       .borderWidth(1)
                       .accentColor(.green)
                       .padding(0)
                       .background(.black)
            Spacer()
        }
    }
}

struct PickerPlus_Previews: PreviewProvider {
    
    
    static var previews: some View {
        PreviewPickerPlus()
    }
}

extension Shape {
    public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 0) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    public func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 0) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

