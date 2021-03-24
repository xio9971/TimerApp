//
//  ViewController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/16.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
        

    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var picker: UIPickerView! { didSet {picker.delegate = self}}

    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    
//    var timeNumberString = "00:00:00" {
//        didSet{
//            timeLabel.text = timeNumberString
//        }
//    }
    
    // 타이머 실행여부
    var isTimerOn = false
    // 타이머 처음 실행 여부
    var isTimerFirstOn = false
    // 카운트 다운 시간
    var duration = 0
    
    var timer = Timer()
    
    let ttsService = TtsService.shared
    let soundEffectService = SoundEffectService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHidden(isTimerFirstOn)
        picker.backgroundColor = UIColor.black
        picker.setValue(UIColor.white, forKey: "textColor")
        
        
        //picker.setValue(UIFont.systemFont(ofSize: 30, weight: .bold), forKey: "fontSyle")
        //picker.setValue(UIFont.boldSystemFont(ofSize: 4), forKey: "")
    }

//    // 숫자 버튼 터치시 이벤트
//    @objc func touchNumerBtns(_sender: UIButton) {
//
//
//
//        //let inputString = _sender.titleLabel?.text
//
//
//
//
//
//        guard let inputString = _sender.titleLabel?.text
//        else {
//
//            if numEntered.isEmpty {
//                return
//            }
//
//            timeNumberString.removeLast()
//            return
//        }
//
//        let formatter = DateComponentsFormatter()
//
//        formatter.unitsStyle = .positional
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.zeroFormattingBehxavior = .pad
//
//        //numEntered += inputString
//        numEntered = "708"
//        timeLabel.text = formatter.string(from: Double(numEntered) ?? 0)
//        //strongSelf.label.text = formatter.string(from: Double(strongSelf.duration))
//
//
//    }
    
    // 취소 버튼 클릭시
    @IBAction func didTouchCancel(_ sender: UIButton) {

        setInit()
    }

    // play or pause 이벤트
    @IBAction func didTouchPlayorPause(_ sender: UIButton) {
        
        guard durationChk() else {
            return
        }
        
        // toggle() boolean 값 반전
        isTimerOn.toggle()
        showPlayButton(!isTimerOn)
        toggleTimer(on: isTimerOn)
    }
    
    // 선택된 시간이 있는지 확인및 duration set!
    func durationChk() -> Bool {
        
        if isTimerFirstOn == false {
            
            let timeInterval = picker.selectedRow(inComponent: 0) * 3600
            + picker.selectedRow(inComponent: 1) * 60
            + picker.selectedRow(inComponent: 2)
      
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = .pad

            timeLabel.text = formatter.string(from: Double(timeInterval))
            duration = timeInterval
        
            if duration > 0 {
                
                isTimerFirstOn.toggle()
                setHidden(isTimerFirstOn)
            }
        }
        
        if duration == 0 {
            
            let alert = UIAlertController(title: "경고", message: "시간을 설정해 주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return false
        }else {
            return true
        }
        
    }
    
    // 초기화
    func setInit() {
        
        if isTimerFirstOn == true {
        
            // TODO: - 0시 0분 0초 로 초기화, 아래와 다르게 한줄로 쓸수있으면 변경 필요
            // pickerview 0시 0분 0초 로 초기화
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.selectRow(0, inComponent: 1, animated: false)
            picker.selectRow(0, inComponent: 2, animated: false)
            
            // isTimerFirstOn -> false, pickerView 보이도록, timeLabel 안보이도록
            isTimerFirstOn.toggle()
            setHidden(isTimerFirstOn)
            
            // play Button 으로 보이도록, 타이머 사용X
            isTimerOn = false
            showPlayButton(!isTimerOn)
            duration = 0
            
            timer.invalidate()
        }
    }
    
    // play or pause 버튼으로 변경
    func showPlayButton(_ shouldShowPlayButton: Bool) {
        
        let imageName = shouldShowPlayButton ? "playIcon" : "pauseIcon"
        playPauseButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    // pickerview, tiemLabel hiiden 처리
    func setHidden(_ isTimerFirstOn: Bool) {
        
        picker.isHidden = isTimerFirstOn
        timeLabel.isHidden = !isTimerFirstOn
    }
    
    
    func toggleTimer(on: Bool) {
        
        if on {
            
            ttsService.say(ttsService.startStr)
            print(ttsService.startStr)
            
            // 시작을알리고 카운트다운 하게되면 밀리는 경우가 발생,  딜레이 1초
            sleep(1)
            
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
                
                guard let strongSelf = self else { return }
                
                strongSelf.duration -= 1
                
                let formatter = DateComponentsFormatter()
                
                formatter.unitsStyle = .positional
                formatter.allowedUnits = [.hour, .minute, .second]
                formatter.zeroFormattingBehavior = .pad
                
//                print(Double(strongSelf.duration))
//                print(formatter.string(from: Double(strongSelf.duration)))
                strongSelf.timeLabel.text = formatter.string(from: Double(strongSelf.duration))
                
                // 10초 이하부터 카운트다운 시작
                if strongSelf.duration > 0 && strongSelf.duration <= 10 {

                    strongSelf.ttsService.say("\(strongSelf.duration)")
                }else if strongSelf.duration == 0{
                    
                    strongSelf.setInit()
                    // soundEffectService.play 타이머 종료 효과음
                    strongSelf.soundEffectService.play()
                    strongSelf.timer.invalidate()
                }
            })
            
        } else {
            
            ttsService.say(ttsService.endStr)
            timer.invalidate()
        }
    }
}



extension ViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 25
        case 1,2:
            return 60

        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var tempStr = ""
        
        var title = UILabel()
          
        if let view = view {
            
             title = view as! UILabel
        }
        
        title.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        title.textColor = UIColor.white
        title.textAlignment = .center

        switch component {
        case 0:
            tempStr = "\(row) 시"
        case 1:
            tempStr = "\(row) 분"
        case 2:
            tempStr = "\(row) 초"
        default:
            tempStr = ""
        }
        
        title.text =  tempStr

     return title

     }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }

    
    
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return "\(row) 시"
//        case 1:
//            return "\(row) 분"
//        case 2:
//            return "\(row) 초"
//        default:
//            return ""
//        }
//    }
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component {
//        case 0:
//            hour = row
//        case 1:
//            minutes = row
//        case 2:
//            seconds = row
//        default:
//            break;
//        }
//    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//        var str = ""
//
//        switch component {
//        case 0:
//            str = "\(row) 시"
//        case 1:
//            str = "\(row) 분"
//        case 2:
//            str = "\(row) 초"
//        default:
//            str = ""
//        }
//
//        //return NSAttributedString(string: str, attributes: [NSAttributedString.Key.)
//        return NSAttributedString(string: str, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
//    }
}
