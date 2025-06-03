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
    @State private var cardRotation: Double = 0
    @State private var isFlipped: Bool = false
    
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
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            VStack {
                Spacer()
                
                FlashCard(
                    character: currentFlashcard.character,
                    pinyin: currentFlashcard.pinyin,
                    definition: currentFlashcard.definition,
                    showPinyin: showLocalPinyin,
                    showDefinition: alwaysShowDefinition || showDefinition,
                    isFlipped: isFlipped
                )
                .rotation3DEffect(
                    .degrees(cardRotation),
                    axis: (x: 0, y: 1, z: 0)
                )
                .gesture(
                    TapGesture()
                        .onEnded { _ in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                                isFlipped.toggle()
                                cardRotation += 180
                                showDefinition.toggle()
                                viewedFlashcards.insert(currentFlashcard.id)
                            }
                        }
                )
                
                Spacer()
                
                ControlButtons(
                    showPinyin: $showLocalPinyin,
                    showDefinition: $showDefinition,
                    isFlipped: $isFlipped,
                    cardRotation: $cardRotation
                )
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

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(.systemBackground),
                Color(.systemBackground).opacity(0.8)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

struct FlashCard: View {
    let character: String
    let pinyin: String
    let definition: String
    let showPinyin: Bool
    let showDefinition: Bool
    let isFlipped: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
                .frame(height: 400)
            
            VStack(spacing: 24) {
                if !isFlipped {
                    Text(character)
                        .font(.system(size: 100, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                        .transition(.opacity)
                    
                    if showPinyin {
                        Text(pinyin)
                            .font(.system(size: 32, weight: .regular, design: .rounded))
                            .foregroundColor(.blue)
                            .transition(.opacity)
                    }
                } else {
                    Text(definition)
                        .font(.system(size: 28))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
            }
            .padding()
        }
        .padding(.horizontal)
    }
}

struct ControlButtons: View {
    @Binding var showPinyin: Bool
    @Binding var showDefinition: Bool
    @Binding var isFlipped: Bool
    @Binding var cardRotation: Double
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    isFlipped.toggle()
                    cardRotation += 180
                    showDefinition.toggle()
                }
            }) {
                Label(isFlipped ? "Show Character" : "Show Definition", systemImage: "arrow.2.squarepath")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            
            Button(action: {
                withAnimation {
                    showPinyin.toggle()
                }
            }) {
                Label(showPinyin ? "Hide Pinyin" : "Show Pinyin", systemImage: "character.phonetic")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(15)
            }
        }
        .padding(.horizontal)
    }
}