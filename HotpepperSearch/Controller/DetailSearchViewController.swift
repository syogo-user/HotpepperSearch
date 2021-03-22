//
//  DetailSearchViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//

import UIKit
import SCLAlertView

class DetailSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var searchInfoGenleArray = [SearchInfo]()
    var searchInfoAreaArray = [SearchInfo]()
    private var searchConditionArray :[SerachCondition] = []
    private var genreArray  = [Genre]()
    private var shopDataArray = [Shop]()
    private var areaArray = [Area]()
    
    private var buttonSelectCheckDic = [String:Bool]()
    private var selectIndex = 0
    private let cellId = "CellId"
    private let segueId1 = "selectVC"
    private let segueId2 = "resultVC"
    private let segueId3 = "selectAreaVC"
    
    
    @IBOutlet weak var nomiButton: UIButton!
    @IBOutlet weak var tabeButton: UIButton!
    @IBOutlet weak var privateRoomButton: UIButton!
    @IBOutlet weak var noSmokingButton: UIButton!
    @IBOutlet weak var kotatsuButton: UIButton!
    @IBOutlet weak var courseButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
        
    enum actionTag:Int{
        case action1 = 0
        case action2 = 1
        case action3 = 2
        case action4 = 3
        case action5 = 4
        case action6 = 5
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "詳細検索"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.searchButton.layer.cornerRadius = 15
        //カスタムセルを設定
        let nib = UINib(nibName: "SearchConditionCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellId)
        
        
        let buttonArray :[UIButton] = [nomiButton,tabeButton,privateRoomButton,noSmokingButton,kotatsuButton,courseButton]
        
        buttonArray.forEach { (button) in
            button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            button.layer.cornerRadius = 25
            button.layer.borderWidth = 0.1
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.searchButtonSetEnable()
        self.searchConditionArray = []
        //タイトルと受け取った検索条件を設定
        self.setTitleText()
        tableView.reloadData()
    }
    private func searchButtonSetEnable(){
        if searchInfoGenleArray.count > 0 || searchInfoAreaArray.count > 0{
            self.searchButton.isEnabled = true//活性
            self.searchButton.setTitleColor(UIColor.white, for: .normal)
            self.searchButton.backgroundColor = UIColor(red: 215/255, green: 56/255, blue: 32/255, alpha: 1)
        }else{
            self.searchButton.isEnabled = false//非活性
            self.searchButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.searchButton.backgroundColor = UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1)
        }

        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchConditionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchConditionCell

        //セルに値を設定
        cell.setData(searchConditionArray[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator//矢印
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セル選択時に呼ばれる
        //条件設定画面に渡す情報を取得
        fetchItemSearchInfo(index:indexPath.row)
    }


    private func fetchItemSearchInfo(index:Int){
        let params = [String:String]()
        self.selectIndex = index
        
        switch index {
        case 0:
            //エリア
            API.shared.request(path: .large_area, params: params, type: LargeAreaItems.self) { (items) in
                //戻ってきたときに呼ばれる
                self.areaArray = items.results.large_area
                //条件設定画面に遷移
                self.performSegue(withIdentifier:self.segueId3 , sender: nil)
            }
        case 1:
            //ジャンル
            API.shared.request(path: .genre, params: params, type: Items.self) { (items) in
                //戻ってきたときに呼ばれる
                self.genreArray = items.results.genre
                //条件設定画面に遷移
                self.performSegue(withIdentifier:self.segueId1 , sender: nil)
            }
        default:
            break
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case segueId1:
            let vc = segue.destination as! SelectViewController
            vc.genreArray = genreArray
            
        case segueId2:
            let vc = segue.destination as! ResultTableViewController
            vc.shopDataArray = self.shopDataArray
            
        case segueId3:
            let vc = segue.destination as! SelectAreaViewController
            vc.areaArray = areaArray
        default:
            break
        }

        
        
    }
    private func setTitleText(){
        for i in 0 ..< 2{
            var conditionValue = ""
            var title = ""
            switch i {
            case 0:
                title = "エリア"
                self.searchInfoAreaArray.forEach({ (item) in
                    conditionValue = conditionValue  + item.name + ","
                })
            case 1:
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
    
    @objc func tapButton(_ sender :Any){
        if let button = sender as? UIButton{
            var dicName = ""
            if let tag = actionTag(rawValue: button.tag){
                switch tag {
                case .action1:
                    dicName = "nomi"
                case .action2:
                    dicName = "tabe"
                case .action3:
                    dicName = "privateRoom"
                case .action4:
                    dicName = "noSmoking"
                case .action5:
                    dicName = "kotatsu"
                case .action6:
                    dicName = "course"
                }
                button.switchAction(onAction: {
                    //選択状態の場合
                    button.backgroundColor = .darkGray
                    self.buttonSelectCheckDic[dicName] = true
                }) {
                    button.backgroundColor = .clear
                    self.buttonSelectCheckDic[dicName] = false
                }
                
                print("isSelected:",button.isSelected)
            }
        }
    }
    
    
    //検索ボタン押下時
    @IBAction func searchTap(_ sender: Any) {
        var params = [String:Any]()
        
        //エリア(小)
        var areaCode = ""
        self.searchInfoAreaArray.forEach { (item) in
            areaCode = areaCode + item.id + ","
        }
        if areaCode != ""{
            areaCode = areaCode.dropLast().description
            params["small_area"] = areaCode
        }
        //ジャンル
        var genleCode = ""
        self.searchInfoGenleArray.forEach { (item) in
            genleCode = genleCode + item.id + ","
        }
        if genleCode != ""{
            genleCode = genleCode.dropLast().description
            params["genre"] = genleCode
        }
        
        
        //飲み放題
        params["free_drink"] = self.buttonSelectCheckDic["nomi"] ?? false ? 1 : 0 //trueのとき1
        //食べ放題
        params["free_food"] = self.buttonSelectCheckDic["tabe"] ?? false ? 1 : 0 //trueのとき1
        //個室
        params["private_room"] = self.buttonSelectCheckDic["privateRoom"] ?? false ? 1 : 0 //trueのとき1
        //禁煙
        params["non_smoking"] = self.buttonSelectCheckDic["noSmoking"] ?? false ? 1 : 0 //trueのとき1
        //掘りごたつ
        params["horigotatsu"] = self.buttonSelectCheckDic["kotatsu"] ?? false ? 1 : 0 //trueのとき1
        //コース
        params["course"] = self.buttonSelectCheckDic["course"] ?? false ? 1 : 0 //trueのとき1
        
        API.shared.request(path: .gourmet, params: params, type:ShopItems.self ) { (items) in
            //戻ってきたときに呼ばれる
            items.results.shop.forEach { (items) in
                print("items.name:",items.name + "items.budget.name:",items.budget.name + "items.address:",items.address)
            }
            if items.results.shop.count == 0{
                SCLAlertView().showInfo("検索結果は0件です", subTitle: "条件を変更してください", closeButtonTitle: "OK", colorStyle: 0xC1272D)
                return
            }
            self.shopDataArray = items.results.shop
            //条件設定画面に遷移
            self.performSegue(withIdentifier:self.segueId2 , sender: nil)
        }
        
    }

}
