import SwiftUI
import Foundation
import UIKit

struct UserDefaultsKeys {
    static let alwaysShowDefinition = "AlwaysShowDefinition"
    static let viewedFlashcards = "ViewedFlashcards"
    static let showPinyin = "ShowPinyin"
    static let hasLaunchedBefore = "HasLaunchedBefore"
    static let isShuffledKey = "IsShuffledKey"
}


class Flashcard: Identifiable, Codable {
    var id = UUID()
    var character: String
    var pinyin: String
    var definition: String
    init(character: String, pinyin: String, definition: String) {
        self.character = character
        self.pinyin = pinyin
        self.definition = definition
    }
}
///HSK 1 Flashcards
private let flashcardsHSK1: [Flashcard] = [
    Flashcard(character: "爱", pinyin: "ài", definition: "to love; affection; to be fond of; to like"),
    Flashcard(character: "八", pinyin: "bā", definition: "eight; 8"),
    Flashcard(character: "爸爸", pinyin: "bà ba", definition: "father (informal)"),
    Flashcard(character: "杯子", pinyin: "bēi zi", definition: "cup; glass"),
        // End of HSK 1
]
///HSK 2 Flashcards
private let flashcardsHSK2: [Flashcard] = [
    Flashcard(character: "吧", pinyin: "ba", definition: "modal particle indicating polite suggestion;...right?;...OK?"),
    Flashcard(character: "白", pinyin: "bái", definition: "white; snowy; pure; bright; empty; blank; plain; clear; to make clear; in vain; gratuitous; free of charge; reactionary; anti-communist; funeral; to stare coldly; to write wrong character; to state; to explain; vernacular; spoken lines in opera; surname Bai"),
    Flashcard(character: "百", pinyin: "bǎi", definition: "hundred; numerous; all kinds of; surname Bai"),
    Flashcard(character: "帮助", pinyin: "bāng zhù", definition: "assistance; aid; to help; to assist"),
  // End of HSK 2
  ]
///HSK 3 Flashcards
private let flashcardsHSK3: [Flashcard] = [
    Flashcard(character: "啊", pinyin: "a", definition: "modal particle ending sentence, showing affirmation, approval, or consent"),
    Flashcard(character: "阿姨", pinyin: "ā yí", definition: "maternal aunt; step-mother; childcare worker; nursemaid; woman of similar age to one's parents (term of address used by child); CL:个"),
    Flashcard(character: "矮", pinyin: "ǎi", definition: "low; short (in length)"),
  // End of HSK 3
 
]
///HSK 4 Flashcards
private let flashcardsHSK4: [Flashcard] = [
    Flashcard(character: "爱情", pinyin: "ài qíng", definition: "romance; love (romantic); CL:个"),
    Flashcard(character: "安排", pinyin: "ān pái", definition: "to arrange; to plan; to set up"),
    Flashcard(character: "安全", pinyin: "ān quán", definition: "safe; secure; safety; security"),
    Flashcard(character: "按时", pinyin: "àn shí", definition: "on time; before deadline; on schedule"),
 // End of HSK 4
 
    
]
///HSK 5 Flashcards
private let flashcardsHSK5: [Flashcard] = [
    Flashcard(character: "哎", pinyin: "āi", definition: "hey!; (interjection used to attract attention or to express surprise or disapprobation);"),
    Flashcard(character: "唉", pinyin: "āi", definition: "(interjection to express agreement or recognition); to sigh"),
    Flashcard(character: "爱护", pinyin: "ài hù", definition: "to take care of; to treasure; to cherish; to love and protect"),
    Flashcard(character: "爱惜", pinyin: "ài xī", definition: "to cherish; to treasure; to use sparingly"),
    Flashcard(character: "爱心", pinyin: "ài xīn", definition: "compassion; CL:片[pian4]"),
 // End of HSK 5
    
]
// HSK 6 Flashcards
    private let flashcardsHSK6: [Flashcard] = [
        Flashcard(character: "领导", pinyin: "lǐng dǎo", definition: "leader; leadership"),
        Flashcard(character: "科技", pinyin: "kē jì", definition: "science and technology"),
        // Add more HSK 6 flashcards here


]

    


struct ContentView: View {
    @Namespace private var namespace
    enum HSKLevel: Int, CaseIterable {
        case hsk1, hsk2, hsk3, hsk4, hsk5, hsk6
    }
    @State private var selectedHSKLevel: HSKLevel = .hsk1
    @State private var selectedLevel = 1
    @AppStorage(UserDefaultsKeys.alwaysShowDefinition) private var alwaysShowDefinition = false
    @AppStorage(UserDefaultsKeys.showPinyin) private var showPinyin = true
    @AppStorage(UserDefaultsKeys.isShuffledKey) private var isShuffled = false
    @State private var showDefinition = false
    @State private var currentIndex = 0
    @State private var showSettings = false
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var shuffledFlashcards: [Flashcard] = []
    @State private var isFirstLaunch = true
    @State private var viewedFlashcards: Set<UUID> = []
    // Cloud animation states
    @State private var cloud1Move = false
    @State private var cloud2Move = false
    @State private var cloud3Move = false
    
    private var filteredFlashcards: [Flashcard] {
        if searchText.isEmpty {
            return shuffledFlashcards
        } else {
            let lowercasedSearchText = searchText.lowercased()
            let filtered = shuffledFlashcards.filter { flashcard in
                let flashcardPinyin = flashcard.pinyin.lowercased()
                return stripDiacritics(flashcardPinyin).contains(stripDiacritics(lowercasedSearchText))
            }
            print("Search Text: \(lowercasedSearchText)")
            print("Filtered Flashcards: \(filtered)")
            return filtered
        }
    }
    
    private func stripDiacritics(_ input: String) -> String {
        return input.folding(options: .diacriticInsensitive, locale: nil)
    }
    
    private func selectHSKLevel(_ level: HSKLevel) {
        selectedHSKLevel = level
        shuffleFlashcards()
    }
    
    private func shuffleFlashcardsIfNeeded() {
        if isFirstLaunch {
            isFirstLaunch = false
            shuffleFlashcards()
        }
    }
    
    private func shuffleFlashcards() {
        if isShuffled {
            switch selectedHSKLevel {
            case .hsk1:
                shuffledFlashcards = flashcardsHSK1.shuffled()
            case .hsk2:
                shuffledFlashcards = flashcardsHSK2.shuffled()
            case .hsk3:
                shuffledFlashcards = flashcardsHSK3.shuffled()
            case .hsk4:
                shuffledFlashcards = flashcardsHSK4.shuffled()
            case .hsk5:
                shuffledFlashcards = flashcardsHSK5.shuffled()
            case .hsk6:
                shuffledFlashcards = flashcardsHSK6.shuffled()
            }
        } else {
            // Display flashcards in their original order
            switch selectedHSKLevel {
            case .hsk1:
                shuffledFlashcards = flashcardsHSK1
            case .hsk2:
                shuffledFlashcards = flashcardsHSK2
            case .hsk3:
                shuffledFlashcards = flashcardsHSK3
            case .hsk4:
                shuffledFlashcards = flashcardsHSK4
            case .hsk5:
                shuffledFlashcards = flashcardsHSK5
            case .hsk6:
                shuffledFlashcards = flashcardsHSK6
            }
        }
    }
    
    
    struct SearchBar: View {
        @Binding var text: String
        @Binding var isSearching: Bool
        
        var body: some View {
            HStack {
                TextField("Search...", text: $text)
                    .padding(.leading, 24)
                    .onChange(of: text) { _ in
                        isSearching = true
                    }
                
                if isSearching {
                    Button(action: {
                        text = ""
                        isSearching = false
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    })
                    .padding(.trailing, 8)
                    .transition(.move(edge: .trailing))
                    .animation(.spring(), value: isSearching)
                }
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: {
                            // Menu action
                        }) {
                            Menu {
                                ForEach(HSKLevel.allCases, id: \.self) { level in
                                    Button("HSK \(level.rawValue + 1)") {
                                        selectHSKLevel(level)
                                    }
                                }
                            } label: {
                                Image(systemName: "line.horizontal.3")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.leading, 32)
                        
                        Spacer()
                        
                        HStack(spacing: 15) {
                            Text("HSK \(selectedHSKLevel.rawValue + 1)")
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                            
                            Button(action: {
                                shuffleFlashcards()
                            }) {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            
                            NavigationLink(destination: SettingsView(alwaysShowDefinition: $alwaysShowDefinition, showPinyin: $showPinyin, isShuffled: $isShuffled, viewedFlashcards: $viewedFlashcards)) {
                                Image(systemName: "gear")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing, 32)
                    }
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(gradient: Gradient(colors: [
                                    Color(#colorLiteral(red: 0.0, green: 0.4, blue: 0.9, alpha: 1)),
                                    Color(#colorLiteral(red: 0.2, green: 0.6, blue: 1.0, alpha: 1))
                                ]), startPoint: .leading, endPoint: .trailing)
                            )
                            .opacity(0.9)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0)
                    .padding(.bottom, 8)
                    .padding(.horizontal)
                    .padding(.top, 0)
                    
                    SearchBar(text: $searchText, isSearching: $isSearching)
                        .padding(.horizontal)
                        .padding(.top, 1)
                    
                    if isSearching && filteredFlashcards.isEmpty {
                        Spacer()
                        Text("No results found")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(filteredFlashcards) { flashcard in
                                    NavigationLink(destination: FlashcardDetailView(
                                        flashcard: flashcard,
                                        flashcards: filteredFlashcards,
                                        currentIndex: filteredFlashcards.firstIndex(where: { $0.id == flashcard.id }) ?? 0,
                                        onIndexChange: { newIndex in
                                            withAnimation {
                                                if newIndex >= 0 && newIndex < filteredFlashcards.count {
                                                    currentIndex = newIndex
                                                }
                                            }
                                        },
                                        alwaysShowDefinition: $alwaysShowDefinition,
                                        isViewed: viewedFlashcards.contains(flashcard.id),
                                        viewedFlashcards: $viewedFlashcards,
                                        showPinyin: $showPinyin
                                    )) {
                                        FlashcardView(flashcard: flashcard, isViewed: viewedFlashcards.contains(flashcard.id), showPinyin: showPinyin)
                                            .padding(8)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .shadow(color: Color.gray.opacity(0.4), radius: 4, x: 0, y: 2)
                                            .matchedGeometryEffect(id: flashcard.id, in: namespace)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                        }
                        
                    }
                }
            }
            .navigationBarHidden(true)
            .ignoresSafeArea(edges: .top)
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                if UserDefaults.standard.object(forKey: UserDefaultsKeys.isShuffledKey) == nil {
                    isShuffled = false // Set the default value (false in this case)
                    UserDefaults.standard.set(isShuffled, forKey: UserDefaultsKeys.isShuffledKey)
                }
                shuffleFlashcardsIfNeeded()
            }
        }
    }
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
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
        }
        
        private var currentFlashcard: Flashcard {
            flashcards[localCurrentIndex]
        }
        
        var body: some View {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)).opacity(0.1),
                    Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1)).opacity(0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    Spacer()
                    VStack(spacing: 24) {
                        HStack {
                            Button(action: {
                                withAnimation {
                                    let newIndex = (localCurrentIndex - 1 + flashcards.count) % flashcards.count
                                    animateTransition {
                                        localCurrentIndex = newIndex
                                        onIndexChange(newIndex)
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.left.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                                    .opacity(0.6)
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                            
                            Text(currentFlashcard.character)
                                .font(.system(size: 72, weight: .medium, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)))
                                .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                                .scaleEffect(scale)
                                .offset(x: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .updating($dragOffset) { value, state, _ in
                                            state = value.translation.width
                                        }
                                        .onEnded { value in
                                            let threshold: CGFloat = 50
                                            if value.translation.width > threshold {
                                                // Swipe right - go to previous
                                                let newIndex = (localCurrentIndex - 1 + flashcards.count) % flashcards.count
                                                animateTransition {
                                                    localCurrentIndex = newIndex
                                                    onIndexChange(newIndex)
                                                }
                                            } else if value.translation.width < -threshold {
                                                // Swipe left - go to next
                                                let newIndex = (localCurrentIndex + 1) % flashcards.count
                                                animateTransition {
                                                    localCurrentIndex = newIndex
                                                    onIndexChange(newIndex)
                                                }
                                            }
                                        }
                                )
                                .animation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0), value: dragOffset)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    let newIndex = (localCurrentIndex + 1) % flashcards.count
                                    animateTransition {
                                        localCurrentIndex = newIndex
                                        onIndexChange(newIndex)
                                    }
                                }
                            }) {
                                Image(systemName: "chevron.right.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(colorScheme == .dark ? .white : .blue)
                                    .opacity(0.6)
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                        
                        if showLocalPinyin {
                            Text(currentFlashcard.pinyin)
                                .font(.system(size: 32, weight: .regular, design: .rounded))
                                .foregroundColor(colorScheme == .dark ? .white : .blue)
                                .transition(.opacity)
                        }
                        
                        if (alwaysShowDefinition || isViewed || showDefinition) {
                            if (!isViewed || showDefinition) || alwaysShowDefinition {
                                Text(currentFlashcard.definition)
                                    .font(.system(.title3, design: .rounded))
                                    .foregroundColor(colorScheme == .dark ? .white : .primary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                    .transition(.opacity)
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(.green)
                                    .transition(.scale)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            if !isViewed {
                                viewedFlashcards.insert(flashcard.id)
                                saveViewedFlashcards()
                            } else {
                                viewedFlashcards.remove(flashcard.id)
                                saveViewedFlashcards()
                            }
                        }) {
                            VStack {
                                Image(systemName: isViewed ? "eye.slash.fill" : "eye.fill")
                                    .font(.system(size: 24))
                                Text(isViewed ? "Unmark" : "Mark")
                                    .font(.caption)
                            }
                            .foregroundColor(isViewed ? .gray : .blue)
                            .padding()
                            .frame(width: 80, height: 80)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        Button(action: {
                            withAnimation {
                                showLocalPinyin.toggle()
                            }
                        }) {
                            VStack {
                                Image(systemName: "character")
                                    .font(.system(size: 24))
                                Text(showLocalPinyin ? "Hide" : "Pinyin")
                                    .font(.caption)
                            }
                            .foregroundColor(.blue)
                            .padding()
                            .frame(width: 80, height: 80)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        
                        if !alwaysShowDefinition {
                            Button(action: {
                                withAnimation {
                                    showDefinition.toggle()
                                }
                            }) {
                                VStack {
                                    Image(systemName: showDefinition ? "book.closed.fill" : "book.fill")
                                        .font(.system(size: 24))
                                    Text(showDefinition ? "Hide" : "Show")
                                        .font(.caption)
                                }
                                .foregroundColor(.blue)
                                .padding()
                                .frame(width: 80, height: 80)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Circle())
                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.bottom, 50)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(colorScheme == .dark ? .white : .blue)
                    }
                }
            }
        }
        
        private func saveViewedFlashcards() {
            if let viewedFlashcardsData = try? JSONEncoder().encode(viewedFlashcards) {
                UserDefaults.standard.set(viewedFlashcardsData, forKey: UserDefaultsKeys.viewedFlashcards)
            }
        }
        
        private func animateTransition(completion: @escaping () -> Void) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0)) {
                scale = 0.8
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                completion()
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0)) {
                    scale = 1.0
                }
            }
        }
    }
    
    struct FlashcardView: View {
        let flashcard: Flashcard
        let isViewed: Bool
        let showPinyin: Bool
        @Environment(\.colorScheme) private var colorScheme
        
        var body: some View {
            VStack(spacing: 16) {
                Text(flashcard.character)
                    .font(.system(size: 56, weight: .medium, design: .rounded))
                    .foregroundColor(.blue)
                    .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 2)
                
                if isViewed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.system(size: 20))
                }
                
                if showPinyin {
                    Text(flashcard.pinyin)
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.black)
                }
            }
            .padding(8)
        }
    }
    
    struct SettingsView: View {
        @Binding var alwaysShowDefinition: Bool
        @Binding var showPinyin: Bool
        @Binding var isShuffled: Bool
        @Binding var viewedFlashcards: Set<UUID>
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1)), Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        if #available(iOS 16.0, *) {
                            Form {
                                Section {
                                    Toggle(isOn: $alwaysShowDefinition) {
                                        Label {
                                            Text("Always Show Definition")
                                                .font(.system(.body, design: .rounded))
                                                .foregroundColor(.black)
                                        } icon: {
                                            Image(systemName: "text.book.closed")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1))))
                                    
                                    Toggle(isOn: $showPinyin) {
                                        Label {
                                            Text("Show Pinyin")
                                                .font(.system(.body, design: .rounded))
                                                .foregroundColor(.black)
                                        } icon: {
                                            Image(systemName: "character")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1))))
                                    
                                    Toggle(isOn: $isShuffled) {
                                        Label {
                                            Text("Shuffle Cards")
                                                .font(.system(.body, design: .rounded))
                                                .foregroundColor(.black)
                                        } icon: {
                                            Image(systemName: "shuffle")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .toggleStyle(SwitchToggleStyle(tint: Color(#colorLiteral(red: 0, green: 0.4, blue: 0.9, alpha: 1))))
                                }
                                .listRowBackground(Color.white.opacity(0.8))
                            }
                            .scrollContentBackground(.hidden)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                    .navigationBarTitleDisplayMode(.large)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Settings")
                                .font(.system(size: 32, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        
        private func unshuffleFlashcards() {
            isShuffled = false
        }
        
        private func unmarkAllViewedFlashcards() {
            viewedFlashcards.removeAll()
        }
    }
    
    
    struct BoxedFlashcardView: View {
        let flashcard: Flashcard
        
        var body: some View {
            VStack(spacing: 8) {
                Text(flashcard.character)
                    .font(.largeTitle)
                    .padding(.top, 8)
                
                Text(flashcard.pinyin)
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding(.top, 5)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}
