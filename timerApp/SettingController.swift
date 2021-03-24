//
//  SettingController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/20.
//

import UIKit

/*
 dynamic이 아닌 static으로 설정 하여 셀수가 고정적
 셋팅옵션이 더 필요할 경우에는 스토리보드에서 추가
 */
class SettingController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    // 셀 선택시 해당 셀에대한 상세내역으로 이동
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let settingDetailView = self.storyboard?.instantiateViewController(withIdentifier: "SettingDetailView") as! SettingDetailController
    
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell01")
        
        //let tempStr = "info" + String(indexPath.section) + String(indexPath.row)
        
        
        
        switch indexPath {
        case [0, 0]:
            settingDetailView.selectedCell = "soundEffect"
        case [0, 1]:
            settingDetailView.selectedCell = "voiceLanguage"
        default:
            print("default")
        }
        
        if settingDetailView.selectedCell != nil {
            self.navigationController?.pushViewController(settingDetailView, animated: true)
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

// 설정옵션
class settingInfo {
    
    static let setInfo = settingInfo()
    
    // 카운트다운 효과음 파일명
    var soundEffect: String = ""
    // 음성지원 설정
    var voiceLanguage: String = ""
    
    private init() {

        soundEffect = UserDefaults.standard.string(forKey: "soundEffect") ?? "jingles"
        voiceLanguage = UserDefaults.standard.string(forKey: "voiceLanguage") ?? "ko-KR"
    }
}
