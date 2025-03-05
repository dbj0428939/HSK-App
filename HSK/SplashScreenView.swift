import SwiftUI

struct SplashScreenView: View {
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
                LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))]),
                               startPoint: .top,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    VStack {
                        ZStack {
                            Image(systemName: "book.circle.fill")
                                .font(.system(size: 100))
                                .foregroundColor(.white)
                            Text("")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.blue)
                        }
                        Text("HSK")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white.opacity(0.80))
                        
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
                        
                        // Animate numbers appearing one by one
                        for (index, _) in numbersOpacity.enumerated() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 + Double(index) * 0.15) {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    numbersOpacity[index] = 1.0
                                }
                            }
                        }
                        
                        // Final zoom animation before transition
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                            withAnimation(.easeIn(duration: 0.2)) {
                                self.finalScale = 1.5
                                self.opacity = 0
                            }
                            
                            // Transition to main view
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
