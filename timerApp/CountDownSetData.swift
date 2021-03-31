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

        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: Double(time)) ?? "00:00:00"
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
