import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    let isViewed: Bool
    let showPinyin: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(flashcard.character)
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundColor(.black)
            
            if showPinyin {
                Text(flashcard.pinyin)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.blue)
            }
            
            if isViewed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .opacity(0.8)
            }
        }
        .frame(height: 120)
    }
}