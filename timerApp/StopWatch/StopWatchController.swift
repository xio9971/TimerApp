//
//  StopWatchController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/24.
//

import UIKit

class StopWatchController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    // 타이머 실행여부
    var isTimerOn = false
    
    let ttsService = TtsService.shared
    
    var timer = Timer()
    
    var duration = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // 취소 버튼 클릭시
    @IBAction func didTouchReSet(_ sender: UIButton) {

        timer.invalidate()
        isTimerOn = false
        showPlayButton(!isTimerOn)
        duration = 0
        timeLabel.text = "00:00:00"
    }
    
    // play or pause 이벤트
    @IBAction func didTouchPlayorPause(_ sender: UIButton) {
        
        isTimerOn.toggle()
        showPlayButton(!isTimerOn)
        toggleTimer(on: isTimerOn)
    }
    
    // play or pause 버튼으로 변경
    func showPlayButton(_ shouldShowPlayButton: Bool) {
        
        let imageName = shouldShowPlayButton ? "playIcon" : "pauseIcon"
        playPauseButton.setImage(UIImage(named: imageName), for: .normal)
    }
    

    func toggleTimer(on: Bool) {
        
        if on {
            
            ttsService.say(ttsService.startStr)
            
            // 시작을알리고 카운트다운 하게되면 밀리는 경우가 발생,  딜레이 1초
            sleep(1)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.duration += 1
                
                let formatter = DateComponentsFormatter()
                
                formatter.unitsStyle = .positional
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.zeroFormattingBehavior = .pad
                
                strongSelf.timeLabel.text = formatter.string(from: Double(strongSelf.duration))
            })
            
        } else {
            
            ttsService.say(ttsService.endStr)
            timer.invalidate()
        }
    }
}
    
