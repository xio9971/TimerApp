//
//  SoundEffectService.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/19.
//

import Foundation
import AudioToolbox

class SoundEffectService {
    
    func play() {
        
        // 임시 처리
        //let soundUrl = Bundle.main.url(forResource: "Bye Bye", withExtension: "mp3")
        let soundUrl = Bundle.main.url(forResource: settingInfo.setInfo.soundEffect, withExtension: "mp3")
        
        //let tempStr: NSString = NSString(string: soundUrl!.path)
        //print(">>>> \(tempStr.lastPathComponent)")
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundUrl! as CFURL, &soundId)
        AudioServicesPlaySystemSound(soundId)
    }
    
}
