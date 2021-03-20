//
//  DetailSearchViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//

import UIKit

class DetailSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var searchInfoGenleArray = [SearchInfo]()
    private var searchConditionArray :[SerachCondition] = []
    private let cellId = "CellId"
    private let segueId1 = "selectVC"
    private var itemArray  = [Genre]()
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細検索"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        //カスタムセルを設定
        let nib = UINib(nibName: "SearchConditionCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellId)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.searchConditionArray = []
        //タイトルと受け取った検索条件を設定
        self.setTitleText()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchConditionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchConditionCell

        //セルに値を設定
        cell.setData(searchConditionArray[indexPath.row])
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator//矢印
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セル選択時に呼ばれる
        //条件設定画面に渡す情報を取得
        fetchItemSearchInfo()

    }


    private func fetchItemSearchInfo(){
        let params = [String:String]()
        API.shared.request(path: .genre, params: params, type: Items.self) { (items) in
            //戻ってきたときに呼ばれる
            self.itemArray = items.results.genre
            //条件設定画面に遷移
            self.performSegue(withIdentifier:self.segueId1 , sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId1{
           let vc = segue.destination as! SelectViewController
            vc.itemArray = itemArray
        }
    }
    private func setTitleText(){
        for i in 0 ..< 3{
            var conditionValue = ""
            var title = ""
            switch i {
            case 0:
                title = "店名"                
            case 1:
                title = "エリア"
            case 2:
                title = "ジャンル"
                self.searchInfoGenleArray.forEach({ (item) in
                    conditionValue = conditionValue  + item.name + ","
                })
                
            default:
                title = ""
            }
            conditionValue = conditionValue.dropLast().description //最後のカンマを削除
            let searchCondition = SerachCondition(title, conditionValue)
            self.searchConditionArray.append(searchCondition)
        }
    }
    //検索ボタン押下時
    @IBAction func searchTap(_ sender: Any) {
//        API.shared.request(path: .gourmet, params: <#T##[String : Any]#>, type: <#T##Decodable.Protocol#>, completion: <#T##(Decodable) -> Void#>)
    }
}
