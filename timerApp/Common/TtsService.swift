//
//  TtsService.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/18.
//

import UIKit
import AVFoundation

class TtsService {
    
    static let shared = TtsService()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private var rate: Float = AVSpeechUtteranceDefaultSpeechRate

    private var voice = AVSpeechSynthesisVoice(language: "ko-KR")
    
    // settingDetailController 에서 언어 선택시 didset타게 되있음
    var language: String = "" {
        didSet{
            languageChange()
        }
    }
    
    let languageList: [String: String] = ["Korean": "ko-KR", "English": "en-US", "Japanese": "ja-JP", "Chinese": "zh-CN"]
    
    var startStr: String = ""

    var endStr: String = ""
    
    // 객체 생성시 init 에서 language 를 셋팅해주면 didset 부분을 탈줄 알았으나 안탐! languageChange() 로 따로 빼줌
    init() {
        
        language = settingInfo.setInfo.voiceLanguage
        languageChange()
    }
    
    // 언어 변경시
    func languageChange() {
        
        voice = AVSpeechSynthesisVoice(language: language)
        setStartPauseStr()
    }
    
    // 설정된 언어로 시작, 정지 String 셋팅
    func setStartPauseStr() {
        
        switch language{
        case "ko-KR":
            startStr = "시작"
            endStr = "정지"
        case "en-US":
            startStr = "start"
            endStr = "pause"
        case "ja-JP":
            startStr = "詩作"
            endStr = "整地"
        case "zh-CN":
            startStr = "开始"
            endStr = "静止"
        
        default:
            print("default")
        }
    }
    
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
