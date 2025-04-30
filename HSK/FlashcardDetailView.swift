import SwiftUI

struct FlashcardDetailView: View {
    let flashcard: Flashcard
    let flashcards: [Flashcard]
    let currentIndex: Int
    let onIndexChange: (Int) -> Void
    @Binding var alwaysShowDefinition: Bool
    let isViewed: Bool
    @Binding var viewedFlashcards: Set<UUID>
    @Binding var showPinyin: Bool
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showDefinition: Bool = false
    @State private var showLocalPinyin: Bool = false
    @State private var localCurrentIndex: Int
    @State private var scale: CGFloat = 1.0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var offset: CGFloat = 0
    @State private var localFlashcards: [Flashcard]
    @State private var isShuffleActive: Bool = false
    
    init(flashcard: Flashcard, flashcards: [Flashcard], currentIndex: Int, onIndexChange: @escaping (Int) -> Void, alwaysShowDefinition: Binding<Bool>, isViewed: Bool, viewedFlashcards: Binding<Set<UUID>>, showPinyin: Binding<Bool>) {
        self.flashcard = flashcard
        self.flashcards = flashcards
        self.currentIndex = currentIndex
        self.onIndexChange = onIndexChange
        self._alwaysShowDefinition = alwaysShowDefinition
        self.isViewed = isViewed
        self._viewedFlashcards = viewedFlashcards
        self._showPinyin = showPinyin
        self._localCurrentIndex = State(initialValue: currentIndex)
        self._localFlashcards = State(initialValue: flashcards)
    }
    
    private var currentFlashcard: Flashcard {
        localFlashcards[localCurrentIndex]
    }
    
    private func shuffleFlashcards() {
        withAnimation {
            isShuffleActive.toggle()
            let currentCard = localFlashcards[localCurrentIndex]
            localFlashcards.shuffle()
            if let newIndex = localFlashcards.firstIndex(where: { $0.id == currentCard.id }) {
                localCurrentIndex = newIndex
                onIndexChange(newIndex)
            }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)).opacity(0.1),
                Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1)).opacity(0.1)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                VStack(spacing: 24) {
                    Text(currentFlashcard.character)
                        .font(.system(size: 72, weight: .medium, design: .rounded))
                        .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)))
                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        .scaleEffect(scale)
                        .offset(x: dragOffset)
                    
                    if showLocalPinyin {
                        Text(currentFlashcard.pinyin)
                            .font(.system(size: 32, weight: .regular, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                            .transition(.opacity)
                            .offset(x: dragOffset)
                    }
                    
                    if (alwaysShowDefinition || showDefinition) {
                        Text(currentFlashcard.definition)
                            .font(.system(size: 24))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .transition(.opacity)
                            .offset(x: dragOffset)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            showDefinition.toggle()
                            viewedFlashcards.insert(currentFlashcard.id)
                        }
                    }) {
                        Text(showDefinition ? "Hide Definition" : "Show Definition")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        withAnimation {
                            showLocalPinyin.toggle()
                        }
                    }) {
                        Text(showLocalPinyin ? "Hide Pinyin" : "Show Pinyin")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom, 30)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            showLocalPinyin = showPinyin
            if !viewedFlashcards.contains(currentFlashcard.id) {
                viewedFlashcards.insert(currentFlashcard.id)
            }
        }
    }
}