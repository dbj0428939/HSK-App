import SwiftUI

struct Cloud: View {
    let offsetX: CGFloat
    let offsetY: CGFloat
    let scale: CGFloat
    let opacity: Double
    
    var body: some View {
        Circle()
            .fill(Color.white)
            .frame(width: 100, height: 100)
            .scaleEffect(scale)
            .offset(x: offsetX, y: offsetY)
            .opacity(opacity)
    }
}
