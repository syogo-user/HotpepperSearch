//
//  DetailSearchViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//

import UIKit
import SCLAlertView
import SVProgressHUD
class DetailSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

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
    

    @IBOutlet weak var textField: SearchTextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearButton: UIButton!
    
    enum detaileItemName:String{
        case nomi
        case tabe
        case privateRoom
        case noSmoking
        case kotatsu
        case course
    }
    
    
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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.searchButton.layer.cornerRadius = 15
        self.clearButton.layer.cornerRadius  = 15
        self.clearButton.layer.borderWidth = 0.3
        self.textField.layer.cornerRadius = 15
        self.textField.borderStyle = .none
        self.textField.layer.borderColor = UIColor.lightGray.cgColor
        self.textField.layer.borderWidth  = 1
        self.textField.layer.masksToBounds = true
        self.tableView.isScrollEnabled = false
        self.textField.attributedPlaceholder = NSAttributedString(string: "キーワードを入力", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])

        
        let gesture = UITapGestureRecognizer(target:self,action: #selector(dismissKeyborad))
        gesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(gesture)

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
        self.searchConditionArray = []
        //タイトルと受け取った検索条件を設定
        self.setTitleText()
        tableView.reloadData()
    }
    @objc private func dismissKeyborad(){
        //キーボードを閉じる
        self.view.endEditing(true)
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
            var imageName = ""
            var conditionValue = ""
            var title = ""
            switch i {
            case 0:
                imageName = "japan"
                title = "エリア"
                self.searchInfoAreaArray.forEach({ (item) in
                    conditionValue = conditionValue  + item.name + ","
                })
            case 1:
                imageName = "spoonFork"
                title = "ジャンル"
                self.searchInfoGenleArray.forEach({ (item) in
                    conditionValue = conditionValue  + item.name + ","
                })
                
            default:
                title = ""
            }
            conditionValue = conditionValue.dropLast().description //最後のカンマを削除
            let searchCondition = SerachCondition(imageName,title, conditionValue)
            self.searchConditionArray.append(searchCondition)
        }
    }
    
    @objc func tapButton(_ sender :Any){
        if let button = sender as? UIButton{
            var dicName = ""
            if let tag = actionTag(rawValue: button.tag){
                switch tag {
                case .action1:
                    dicName = detaileItemName.nomi.rawValue
                case .action2:
                    dicName = detaileItemName.tabe.rawValue
                case .action3:
                    dicName = detaileItemName.privateRoom.rawValue
                case .action4:
                    dicName = detaileItemName.noSmoking.rawValue
                case .action5:
                    dicName = detaileItemName.kotatsu.rawValue
                case .action6:
                    dicName = detaileItemName.course.rawValue
                }
                button.switchAction(onAction: {
                    //選択状態の場合
                    button.backgroundColor = .darkGray
                    self.buttonSelectCheckDic[dicName] = true
                }) {
                    button.backgroundColor = .clear
                    self.buttonSelectCheckDic[dicName] = false
                }
                
            }
        }
    }
    //クリアボタン押下時
    @IBAction func clearTap(_ sender: Any) {
        //キーワードをクリア
        self.textField.text = ""
        
        self.searchInfoAreaArray = []
        self.searchInfoGenleArray = []
        self.searchConditionArray = []
        self.buttonSelectCheckDic[detaileItemName.nomi.rawValue] = false
        self.buttonSelectCheckDic[detaileItemName.tabe.rawValue] = false
        self.buttonSelectCheckDic[detaileItemName.privateRoom.rawValue] = false
        self.buttonSelectCheckDic[detaileItemName.noSmoking.rawValue] = false
        self.buttonSelectCheckDic[detaileItemName.kotatsu.rawValue] = false
        self.buttonSelectCheckDic[detaileItemName.course.rawValue] = false        
        self.nomiButton.backgroundColor = .clear
        self.tabeButton.backgroundColor = .clear
        self.privateRoomButton.backgroundColor = .clear
        self.noSmokingButton.backgroundColor = .clear
        self.kotatsuButton.backgroundColor = .clear
        self.courseButton.backgroundColor = .clear
        
        setTitleText()
        tableView.reloadData()
    }
    
    //検索ボタン押下時
    @IBAction func searchTap(_ sender: Any) {
        SVProgressHUD.show()
        if !self.validateCheck() {
            SVProgressHUD.dismiss()
            SCLAlertView().showInfo("検索条件が設定されていません。", subTitle: "キーワード、エリア、ジャンルのどれかを選択してください。", closeButtonTitle: "OK", colorStyle: 0xC1272D)
            return
        }
        
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
        
        //キーワード
        let keyword = self.textField.text ?? ""
        if keyword != ""{
            params["keyword"] = keyword
        }
        
        API.shared.request(path: .gourmet, params: params, type:ShopItems.self ) { (items) in
            //戻ってきたときに呼ばれる
            items.results.shop.forEach { (items) in
                print("items.name:",items.name + "items.budget.name:",items.budget.name + "items.address:",items.address)
            }
            if items.results.shop.count == 0{
                SVProgressHUD.dismiss()
                SCLAlertView().showInfo("検索結果は0件です", subTitle: "条件を変更してください", closeButtonTitle: "OK", colorStyle: 0xC1272D)
                return
            }
            self.shopDataArray = items.results.shop
            //条件設定画面に遷移
            self.performSegue(withIdentifier:self.segueId2 , sender: nil)
            SVProgressHUD.dismiss()
        }
        
    }
    private func validateCheck() -> Bool{
        if searchInfoGenleArray.count ==  0 && searchInfoAreaArray.count == 0 && self.textField.text == ""{
            return false
        } else {
            return true
        }
    }

}
