import SwiftUI

struct Cloud: View {
    let offsetX: CGFloat
    let offsetY: CGFloat
    let scale: CGFloat
    let opacity: Double
    @State private var move = false
    
    var body: some View {
        Image(systemName: "cloud.fill")
            .font(.system(size: 100))
            .foregroundColor(.white)
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(x: move ? offsetX : CGFloat.random(in: -offsetX/2...0), y: offsetY)
            .onAppear {
                withAnimation(.linear(duration: Double.random(in: 8...12)).repeatForever(autoreverses: false)) {
                    move = true
                }
            }
    }
    
    init(offsetX: CGFloat, offsetY: CGFloat, scale: CGFloat, opacity: Double) {
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.scale = scale
        self.opacity = opacity
        self._move = State(initialValue: false)
    }
}



struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var numbersOpacity = Array(repeating: 0.0, count: 6)
    @State private var finalScale = 1.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))
                ]),
                startPoint: .top,
                endPoint: .bottom)
                .ignoresSafeArea()
                

                
                // Cloud layers - Top section
                Cloud(offsetX: UIScreen.main.bounds.width + 100, offsetY: -UIScreen.main.bounds.height/3, scale: 1.5, opacity: 0.2)
                Cloud(offsetX: UIScreen.main.bounds.width + 200, offsetY: -UIScreen.main.bounds.height/4, scale: 1.3, opacity: 0.3)
                Cloud(offsetX: UIScreen.main.bounds.width + 150, offsetY: -UIScreen.main.bounds.height/6, scale: 1.2, opacity: 0.2)
                
                // Cloud layers - Middle section
                Cloud(offsetX: UIScreen.main.bounds.width + 180, offsetY: 0, scale: 1.4, opacity: 0.25)
                Cloud(offsetX: UIScreen.main.bounds.width + 120, offsetY: UIScreen.main.bounds.height/6, scale: 1.3, opacity: 0.2)
                
                // Cloud layers - Bottom section
                Cloud(offsetX: UIScreen.main.bounds.width + 160, offsetY: UIScreen.main.bounds.height/3, scale: 1.5, opacity: 0.3)
                Cloud(offsetX: UIScreen.main.bounds.width + 140, offsetY: UIScreen.main.bounds.height/2.5, scale: 1.2, opacity: 0.2)
                
                VStack {
                    VStack(spacing: 0) {
                        ZStack {
                            Image(systemName: "book.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                            Text("")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        .padding(.top, 0)
                        
                        Text("HSK")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.80))
                            .padding(.top, 5)
                        
                        Text("汉语水平考试")
                            .font(.system(size: 25, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.80))
                            .opacity(numbersOpacity[0])
                        
                        HStack(spacing: 15) {
                            Text("1")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(numbersOpacity[1])
                            Text("-")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(numbersOpacity[2])
                            Text("6")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(numbersOpacity[3])
                        }
                        .padding(.top, 5)
                    }
                    .scaleEffect(size)
                    .scaleEffect(finalScale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                        
                        for (index, _) in numbersOpacity.enumerated() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + Double(index) * 0.15) {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    numbersOpacity[index] = 1.0
                                }
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.finalScale = 1.5
                                self.opacity = 0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation {
                                    self.isActive = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
