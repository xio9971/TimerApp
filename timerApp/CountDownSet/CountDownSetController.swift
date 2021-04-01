//
//  CountDownSetController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/25.
//

import UIKit

class CountDownSetController: UIViewController {

    @IBOutlet weak var timerName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    let listManage = ListManageService.shared
    let ttsService = TtsService.shared
    var timer = Timer()
    let soundEffectService = SoundEffectService()
    var duration = 0
    var currentPlayInedx = 0
    
    // 타이머 실행여부
    var isTimerOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // 다른 텝바들과 ui를 맞춰주기위해서 네비게이션바 숨김
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    
        dataRefresh()
    }

    // 리셋 버튼 클릭시
    @IBAction func didTouchReSet(_ sender: UIButton) {
        
        isTimerOn = false
        showPlayButton(!isTimerOn)
        timer.invalidate()
        dataRefresh()
    }
    
    // play or pause 이벤트
    @IBAction func didTouchPlayorPause(_ sender: UIButton) {
        
        // toggle() boolean 값 반전
        isTimerOn.toggle()
        showPlayButton(!isTimerOn)
        toggleTimer(on: isTimerOn)
    }
    
    /**
     카운트다운 리스트 설정 버튼 클릭시
     타이머 종료
     */
    @IBAction func contDownListSet(_ sender: UIButton) {
        
        isTimerOn = false
        showPlayButton(!isTimerOn)
        timer.invalidate()
    }
    
    // play or pause 버튼으로 변경
    func showPlayButton(_ shouldShowPlayButton: Bool) {
        
        let imageName = shouldShowPlayButton ? "playIcon" : "pauseIcon"
        playPauseButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // 카운트 다운 새로고침
    func dataRefresh() {
        
        // 저장된 카운트다운리스트가 없을경우
        if listManage.dataList.count == 0 {
        
            duration = 0
            currentPlayInedx = 0
            timerName.text = ""
            timeLabel.text = "00:00:00"
        }else {
            
            duration = listManage.dataList[0].time
            currentPlayInedx = 0
            timerName.text = listManage.dataList[0].name
            timeLabel.text = timeFormatting(duration: Double(listManage.dataList[0].time))
        }
    }
    
    func toggleTimer(on: Bool) {
        
        if on {
            
            ttsService.say(ttsService.startStr)
            
            // 시작을알리고 카운트다운 하게되면 밀리는 경우가 발생,  딜레이 1초
            sleep(1)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.duration -= 1
                
                let formatter = DateComponentsFormatter()
                
                formatter.unitsStyle = .positional
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.zeroFormattingBehavior = .pad
                
                strongSelf.timeLabel.text = formatter.string(from: Double(strongSelf.duration))
                
                // 10초 이하부터 카운트다운 시작
                if strongSelf.duration > 0 && strongSelf.duration <= 10 {

                    strongSelf.ttsService.say("\(strongSelf.duration)")
                }else if strongSelf.duration == 0{
                    
                    let maxIndex = strongSelf.listManage.dataList.count - 1
                    
                    if(maxIndex > strongSelf.currentPlayInedx) {
                        
                        strongSelf.currentPlayInedx += 1
                        strongSelf.duration = strongSelf.listManage.dataList[strongSelf.currentPlayInedx].time
                        strongSelf.timerName.text = strongSelf.listManage.dataList[strongSelf.currentPlayInedx].name
                        strongSelf.timeLabel.text = strongSelf.listManage.dataList[strongSelf.currentPlayInedx].hhmmssTime
                    }else {
                        
                        strongSelf.soundEffectService.play()
                        strongSelf.timer.invalidate()
                        strongSelf.dataRefresh()
                        strongSelf.isTimerOn = false
                        strongSelf.showPlayButton(!strongSelf.isTimerOn)
                    }
                    
                }
            })
            
        } else {
            
            ttsService.say(ttsService.endStr)
            timer.invalidate()
        }
    }

}
