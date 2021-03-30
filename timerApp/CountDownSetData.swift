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
