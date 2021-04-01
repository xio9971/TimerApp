//
//  CountDownSetData.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/26.
//

import Foundation

struct CountDownSetData: Codable {

    var tag: Int
    var name: String
    var time: Int
    
    var hhmmssTime: String  {
        return timeFormatting(duration: Double(time))
    }
    

}

// TimeInterval을 HH:MM:SS 으로 포멧팅
func timeFormatting(duration: Double?) -> String {
    
    guard let duration = duration else {
        return ""
    }
    
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.zeroFormattingBehavior = .pad
    
    return formatter.string(from: duration)!
}

func calInterval(hh: Int, mm: Int, ss: Int) -> Int {
    return hh * 3600 + mm * 60 + ss
}


