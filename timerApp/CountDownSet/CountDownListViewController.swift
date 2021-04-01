//
//  CountDownListViewController.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/25.
//

import UIKit

class CountDownListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! { didSet {tableView.delegate = self}}
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    let listManage = ListManageService.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 전 화면에서 다른 텝바들과 ui를 맞춰주기위해서 네비게이션바 숨김한것을 해지함
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        // 테이블뷰 높이 설정
        self.tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이타 로드후 테이블뷰 갱신
        tableView.reloadData()
    }
    

    
    /**
     타이머 추가 버튼클릭시
     */
    @IBAction func didTouchAddBtn(_ sender: UIButton) {

//        let tempStruct: CountDownSetData = CountDownSetData(tag: 1, name: "", time: 50)
//        self.dataList.append(tempStruct)
        //tableView.reloadData()

        let CountDownListSetView = self.storyboard?.instantiateViewController(withIdentifier: "CountDownListSetView") as! CountDownListSetViewController

        self.navigationController?.pushViewController(CountDownListSetView, animated: true)
    }
    

    /**
     네비게이션 바 Edit 버튼 클릭시
     */
    @IBAction func didTouchEditBtn(_ sender: UIButton) {
        
//        tableView.isEditing.toggle()
//        editBtn.title = tableView.isEditing ? "Done" : "Edit"
        
        if tableView.isEditing {
            
            tableView.isEditing = false
            editBtn.title = "Edit"
            listManage.save()
        }else {
            
            tableView.isEditing = true
            editBtn.title = "Done"
        }
    }
    
    
}

extension CountDownListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listManage.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountDownListCell
        else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = listManage.dataList[indexPath.row].name
        cell.timeLable.text = listManage.dataList[indexPath.row].hhmmssTime
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let CountDownListSetView = self.storyboard?.instantiateViewController(withIdentifier: "CountDownListSetView") as! CountDownListSetViewController

        //CountDownListSetView.dataList = self.dataList
        CountDownListSetView.index = indexPath.row
        

        self.navigationController?.pushViewController(CountDownListSetView, animated: true)
    }
    
    // 삭제시
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            listManage.dataList.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            listManage.save()
        }
    }

    // 셀순서 변경 가능하도록함
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // 셀순서 변경시
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        listManage.dataList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
}




class CountDownListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
     
}
