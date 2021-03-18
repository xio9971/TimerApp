//
//  TtsService.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/18.
//

import UIKit
import AVFoundation

class TtsService {
    
    private let synthesizer = AVSpeechSynthesizer()
    
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
//    var voice = AVSpeechSynthesisVoice(language: "en-GB")
    var voice = AVSpeechSynthesisVoice(language: "ko-KR")
    
    func say(_ phrase: String) {
        
        //guard UIAccessibility.isVoiceOverRunning else { return }
        
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.rate = rate
        utterance.voice = voice
        
        synthesizer.speak(utterance)
    }
    
    func getVoices() {
        
        AVSpeechSynthesisVoice.speechVoices().forEach({ print($0.language) })
    }
}
