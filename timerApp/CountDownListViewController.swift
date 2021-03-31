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
    
    static let shared = CountDownListViewController()
    
    var dataList: [CountDownSetData] = []
    
    var url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("dataList.json")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.tableView.rowHeight = 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 데이타 로드후 테이블뷰 갱신
        loadData()
        tableView.reloadData()
    }
    
    /**
     저장된 데이터 불러오기
     */
    func loadData() {
        
        let jsonDecorder: JSONDecoder = JSONDecoder()
        
        /*
         기존에는 NSDataAsset 을 이용하여 데이터 관리
         -> FileManager 를 이용하여 데이터 관리로 변경
         */
        
//        guard let dataList: NSDataAsset = NSDataAsset.init(name: "dataList") else {
//            return
//        }
//
//        do {
//            self.dataList = try jsonDecorder.decode([CountDownSetData].self, from: dataList.data)
//        }catch{
//            print(error.localizedDescription)
//        }
        
        
        /*
         기존에는 url 을 guard문 으로 옵셔널 체크
         -> 전역변수로 url 변경
         */
        
//        guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            return
//        }
//
//        url.appendPathComponent("dataList.json")
    
        
        if FileManager.default.fileExists(atPath: url.path) {
            
            // Try Catch
            do {
            
                // 불러오기
                //let text = try String(contentsOf: url!, encoding: .utf8)
                //self.dataList = try jsonDecorder.decode([CountDownSetData].self, from: text.data(using: .utf8)!)
                guard let data = FileManager.default.contents(atPath: url.path) else { return }
                self.dataList = try jsonDecorder.decode([CountDownSetData].self, from: data)
            } catch let e {
                
                // 에러처리
                print(e.localizedDescription)
            }
        }else {
            return
        }
    
    }
    
    // 저장
    func save(saveList: [CountDownSetData]) {
        
        let jsonEncoder = JSONEncoder()
            
        do {
            
            let data = try jsonEncoder.encode(saveList)
            try data.write(to: url)
        } catch  {
            
            print(error)
        }
    
    }
    
    /**
     타이머 추가 버튼클릭시
     */
    @IBAction func didTouchAddBtn(_ sender: UIButton) {

//        let tempStruct: CountDownSetData = CountDownSetData(tag: 1, name: "", time: 50)
//        self.dataList.append(tempStruct)
        //tableView.reloadData()

        let CountDownListSetView = self.storyboard?.instantiateViewController(withIdentifier: "CountDownListSetView") as! CountDownListSetViewController

        CountDownListSetView.dataList = self.dataList
        
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
            save(saveList: self.dataList)
        }else {
            tableView.isEditing = true
            editBtn.title = "Done"
        }
    }
    
    
}

extension CountDownListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountDownListCell
        else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = dataList[indexPath.row].name
        cell.timeLable.text = dataList[indexPath.row].hhmmssTime
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let CountDownListSetView = self.storyboard?.instantiateViewController(withIdentifier: "CountDownListSetView") as! CountDownListSetViewController

        CountDownListSetView.dataList = self.dataList
        CountDownListSetView.index = indexPath.row
        

        self.navigationController?.pushViewController(CountDownListSetView, animated: true)
    }
    
    // 삭제시
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            dataList.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            save(saveList: self.dataList)
        }
    }

    // 셀순서 변경 가능하도록함
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // 셀순서 변경시
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        dataList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
}




class CountDownListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
     
}
