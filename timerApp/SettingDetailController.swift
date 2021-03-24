//
//  SettingDetailController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/20.
//

import UIKit

class SettingDetailController: UITableViewController {

    private var dataArr: [String] = []
    public var selectedCell: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailSet()
    }
    
    func detailSet() {
        
        guard let setName = self.selectedCell else {
            return
        }
        
        switch setName {
        // 카운트다운 음성
        case "soundEffect":
            
            // 번들안에있는 mp3 파일 url을 배열로 받아옴
            guard let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
            else {
                return
            }
            
            // 받아온 url들 에서 파일명을 뽑아서 변수에 저장
            for i in 0..<urls.count  {
                
                // lastPathComponent -> xxxx.mp3  (마지막경로 반환)
                // deletingPathExtension -> xxxx  (확장자제거)
                var fileName = (NSString(string: urls[i].path).lastPathComponent as NSString).deletingPathExtension
                
                dataArr.append(fileName)
            }
        
        case "voiceLanguage":
    
            for key in TtsService.shared.languageList.keys {
                
                dataArr.append(key)
            }
            
        default:
            print("default")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        // cell text 변경
        cell.nameLabel.text = dataArr[indexPath.row]
        
        
        guard let setName = self.selectedCell else {
            return cell
        }

        // setName을 기준으로 분기 추가될 예정..
        switch setName {
        // 카운트다운 음성
        case "soundEffect":

            // 설정된 효과음 체크
            if settingInfo.setInfo.soundEffect == dataArr[indexPath.row] {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        case "voiceLanguage":

            // 설정된 효과음 체크
            if settingInfo.setInfo.voiceLanguage == TtsService.shared.languageList[dataArr[indexPath.row]]{
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        default:
            print("default")
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let setName = self.selectedCell else {
            return
        }
        
        // setName을 기준으로 분기 추가될 예정..
        switch setName {
        // 카운트다운 음성
        case "soundEffect":

            // 선택한음성을 키 : countDownSoundFileName 로 카운트다운 음성 설정
            UserDefaults.standard.set(dataArr[indexPath.row], forKey: "soundEffect")
            settingInfo.setInfo.soundEffect = dataArr[indexPath.row]
            self.navigationController?.popViewController(animated: true)
        case "voiceLanguage":

            var language = TtsService.shared.languageList[dataArr[indexPath.row]]
            
            UserDefaults.standard.set(language, forKey: "voiceLanguage")
            settingInfo.setInfo.voiceLanguage = language!
            TtsService.shared.language = language!
            
            self.navigationController?.popViewController(animated: true)
        default:
            print("default")
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!

}
