import SwiftUI

public extension Font {
    
    static func fontBold(size: CGFloat) -> Font {
        Font.custom("DMSans-Bold", size: size)
     }
    static func fontMedium(size: CGFloat) -> Font {
        Font.custom("DMSans-Medium", size: size)
     }
    static func fontRegular(size: CGFloat) -> Font {
        Font.custom("DMSans-Regular", size: size)
     }
    
}
