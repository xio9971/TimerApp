//
//  CircleButton.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/18.
//

import Foundation
import UIKit

// 인터페이스 빌더에서 디자인으로 확인 가능 가능하도록 IBDesignable
@IBDesignable
class CircleButton: UIButton {
    
    // IBInspectable 인스펙터 패널에서 사용될 수 있도록 설정
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
        
    }
    
}
