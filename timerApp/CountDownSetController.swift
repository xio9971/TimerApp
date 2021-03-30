//
//  CountDownSetController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/25.
//

import UIKit

class CountDownSetController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // 다른 텝바들과 ui를 맞춰주기위해서 네비게이션바 숨김
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
 
    // play or pause 이벤트₩
    @IBAction func didTouchPlayorPause(_ sender: UIButton) {
        
        
        // toggle() boolean 값 반전
//        isTimerOn.toggle()
//        showPlayButton(!isTimerOn)
//        toggleTimer(on: isTimerOn)
    }
 

}
