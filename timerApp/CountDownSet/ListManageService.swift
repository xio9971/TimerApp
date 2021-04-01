//
//  ListManageService.swift
//  timerApp
//
//  Created by 정창규 on 2021/03/31.
//

import Foundation

class ListManageService {
    
    static let shared = ListManageService()
    
    var dataList: [CountDownSetData] = []
    
    var url: URL
    

    init() {
        
        url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("dataList.json")
        
        loadData()
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
  
    func save() {
        
        let jsonEncoder = JSONEncoder()
            
        do {
            
            let data = try jsonEncoder.encode(self.dataList)
            try data.write(to: url)
        } catch  {
            
            print(error)
        }
    
    }
    
    // 저장
//    func save(saveList: [CountDownSetData]) {
//
//        let jsonEncoder = JSONEncoder()
//
//        do {
//
//            let data = try jsonEncoder.encode(saveList)
//            try data.write(to: url)
//        } catch  {
//
//            print(error)
//        }
//
//    }
}
