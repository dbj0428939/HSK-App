import Foundation
import AVFoundation

class TTSHelper {
    static let shared = TTSHelper()
    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String, language: String = "zh-CN") {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
