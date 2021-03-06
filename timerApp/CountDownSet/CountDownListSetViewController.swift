//
//  CountDownListSetViewController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/29.
//

import UIKit

class CountDownListSetViewController: UIViewController {

    @IBOutlet weak var timerName: UITextField!
    @IBOutlet weak var picker: UIPickerView! { didSet {picker.delegate = self}}
    
    let listManage = ListManageService.shared
    
    /*
     tagNum 이라는 변수로 원래 의도한것은
     셀순서를 변경해도 변경한 셀 순서 대로 tag 값을 변경하여
     타이머 세트 기능 구현시 순서대로 카운팅 되도록 할려고 했음
     
     그런데 json으로 저장할시 셀순서대로 저장 됨으로 tagNum 값이 필요지 않게됨
     혹시나 필요할 수 있음으로 남겨둠
     */
    var index: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerName.layer.borderColor = UIColor.white.cgColor
        timerName.layer.borderWidth = 1
        picker.backgroundColor = UIColor.black
        picker.setValue(UIColor.white, forKey: "textColor")
        
        // 네비게이션바 오른쪽 아이템으로 저장버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(save))
        
        guard let index = self.index else {
            return
        }
        
        timerName.text = listManage.dataList[index].name
        

        let time = listManage.dataList[index].time
        
        picker.selectRow((time / 3600), inComponent: 0, animated: false)
        picker.selectRow((time / 60) % 60, inComponent: 1, animated: false)
        picker.selectRow(time % 60, inComponent: 2, animated: false)
        
    }
    
    
    @objc func save() {
        
        let timeInterval = picker.selectedRow(inComponent: 0) * 3600
        + picker.selectedRow(inComponent: 1) * 60
        + picker.selectedRow(inComponent: 2)
        
        let title = timerName.text!
    
        if title.isEmpty || timeInterval == 0{

            let alert = UIAlertController(title: "경고", message: "타이머 명칭, 시간을 입력해 주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
    
        // index가 있을경우 수정건, 없을경우 신규건으로 판단
        if let index = self.index {
            
            listManage.dataList[index].name = title
            listManage.dataList[index].time = timeInterval
        }else {
            
            var tag = 0
            
            if !listManage.dataList.isEmpty {
                tag = listManage.dataList.max { $0.tag < $1.tag }!.tag + 1
            }
            
            let tempStruct: CountDownSetData = CountDownSetData(tag: tag, name: title, time: timeInterval)
            listManage.dataList.append(tempStruct)
        }
        
        listManage.save()
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CountDownListSetViewController:UIPickerViewDelegate,UIPickerViewDataSource {
    
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

}
