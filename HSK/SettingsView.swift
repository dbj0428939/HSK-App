import SwiftUI

struct SettingsView: View {
    @Binding var alwaysShowDefinition: Bool
    @Binding var showPinyin: Bool
    @Binding var isShuffled: Bool
    @Binding var viewedFlashcards: Set<UUID>
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                // Gradient backdrop adapts to light/dark like SplashScreen
                LinearGradient(
                    gradient: Gradient(colors: colorScheme == .light ? [
                        Color(#colorLiteral(red: 0.1, green: 0.2, blue: 0.9, alpha: 1)),
                        Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.9, alpha: 1)),
                        Color(#colorLiteral(red: 0.0, green: 0.6, blue: 0.9, alpha: 1)),
                        Color(#colorLiteral(red: 0.1, green: 0.7, blue: 0.85, alpha: 1)),
                        Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))
                    ] : [
                        Color(#colorLiteral(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)),
                        Color(#colorLiteral(red: 0.2, green: 0.3, blue: 0.5, alpha: 1))
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Title header card
                        HStack {
                            Text("Settings")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.white.opacity(0.2)))
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        // Display Settings card
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "text.book.closed")
                                    .foregroundColor(.white)
                                Text("Display Settings")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                            }
                            .padding(.bottom, 4)

                            Toggle(isOn: $alwaysShowDefinition) {
                                HStack(spacing: 12) {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(.white)
                                    Text("Always Show Definition")
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.white)

                            Toggle(isOn: $showPinyin) {
                                HStack(spacing: 12) {
                                    Image(systemName: "character.phonetic")
                                        .foregroundColor(.white)
                                    Text("Always Show Pinyin")
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.white)

                            Toggle(isOn: $isShuffled) {
                                HStack(spacing: 12) {
                                    Image(systemName: "shuffle")
                                        .foregroundColor(.white)
                                    Text("Shuffle Cards")
                                        .foregroundColor(.white)
                                }
                            }
                            .tint(.white)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.12))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal, 20)

                        // Progress card
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "chart.bar")
                                    .foregroundColor(.white)
                                Text("Progress")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                            }
                            .padding(.bottom, 4)

                            Button(action: {
                                withAnimation { viewedFlashcards.removeAll() }
                            }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .foregroundColor(.white)
                                    Text("Reset Progress")
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.15))
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.12))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)

                        // Credits & Policy card
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                Text("Credits & Policy")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                            }

                            NavigationLink(destination: AcknowledgementsView()) {
                                HStack {
                                    Image(systemName: "doc.text")
                                        .foregroundColor(.white)
                                    Text("Acknowledgements")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.15))
                                )
                            }

                            Link(destination: URL(string: "https://sites.google.com/view/hsk-flash-privacy-policy/home")!) {
                                HStack {
                                    Image(systemName: "hand.raised")
                                        .foregroundColor(.white)
                                    Text("Privacy Policy")
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color.white.opacity(0.15))
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.12))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                        // About card
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "person.crop.square")
                                    .foregroundColor(.white)
                                Text("About")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                Spacer()
                            }

                            HStack {
                                Image(systemName: "person")
                                    .foregroundColor(.white)
                                Text("Developer: David Johnson")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.white.opacity(0.15))
                            )
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.12))
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Inline fallback views to resolve navigation targets without target membership issues.
struct AcknowledgementsView: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .light ? [
                    Color(#colorLiteral(red: 0.1, green: 0.2, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.0, green: 0.6, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.1, green: 0.7, blue: 0.85, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))
                ] : [
                    Color(#colorLiteral(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.3, blue: 0.5, alpha: 1))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Acknowledgements")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("Word lists (characters and definitions) sourced from hskhsk.com data lists maintained by glxxyz.")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        Link("GitHub: glxxyz/hskhsk.com – data/lists", destination: URL(string: "https://github.com/glxxyz/hskhsk.com/tree/main/data/lists")!)
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.12))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct LicensesView: View {
    private let licenseText = """
MIT License

Copyright (c) 2020 Alan Davies

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""
    
    var body: some View {
        ScrollView {
            Text(licenseText)
                .font(.system(size: 14))
                .padding(20)
        }
        .navigationTitle("Licenses")
    }
}

struct AboutView: View {
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: colorScheme == .light ? [
                    Color(#colorLiteral(red: 0.1, green: 0.2, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.0, green: 0.5, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.0, green: 0.6, blue: 0.9, alpha: 1)),
                    Color(#colorLiteral(red: 0.1, green: 0.7, blue: 0.85, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.8, blue: 0.8, alpha: 1))
                ] : [
                    Color(#colorLiteral(red: 0.1, green: 0.1, blue: 0.2, alpha: 1)),
                    Color(#colorLiteral(red: 0.2, green: 0.3, blue: 0.5, alpha: 1))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        Text("HSK App")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Developer: David Johnson")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.12))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}