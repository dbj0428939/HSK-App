import SwiftUI

struct FlashcardView: View {
    let flashcard: Flashcard
    let isViewed: Bool
    let showPinyin: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
            
            VStack(spacing: 12) {
                Text(flashcard.character)
                    .font(.system(size: 40, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                if showPinyin {
                    Text(flashcard.pinyin)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.blue)
                }
                
                if isViewed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .opacity(0.8)
                        .imageScale(.large)
                }
            }
            .padding()
        }
        .frame(height: 140)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}