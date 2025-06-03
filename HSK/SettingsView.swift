import SwiftUI

struct SettingsView: View {
    @Binding var alwaysShowDefinition: Bool
    @Binding var showPinyin: Bool
    @Binding var isShuffled: Bool
    @Binding var viewedFlashcards: Set<UUID>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle(isOn: $alwaysShowDefinition) {
                        Label("Always Show Definition", systemImage: "text.book.closed")
                    }
                    
                    Toggle(isOn: $showPinyin) {
                        Label("Show Pinyin", systemImage: "character.phonetic")
                    }
                    
                    Toggle(isOn: $isShuffled) {
                        Label("Shuffle Cards", systemImage: "shuffle")
                    }
                } header: {
                    Text("Display Settings")
                }
                
                Section {
                    Button(action: {
                        withAnimation {
                            viewedFlashcards.removeAll()
                        }
                    }) {
                        HStack {
                            Label("Reset Progress", systemImage: "arrow.counterclockwise")
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("Progress")
                }
            }
            .navigationTitle("Settings")
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}