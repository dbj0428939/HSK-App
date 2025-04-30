import SwiftUI

struct SettingsView: View {
    @Binding var alwaysShowDefinition: Bool
    @Binding var showPinyin: Bool
    @Binding var isShuffled: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Display Settings")) {
                    Toggle("Always Show Definition", isOn: $alwaysShowDefinition)
                    Toggle("Show Pinyin", isOn: $showPinyin)
                    Toggle("Shuffle Cards", isOn: $isShuffled)
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