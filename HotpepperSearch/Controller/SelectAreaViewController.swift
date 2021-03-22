//
//  DetailSearchAreaViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import Foundation
import UIKit
class SelectAreaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    enum AreaState:Int{
        case largeArea = 0
        case middleArea = 1
        case smallArea = 2
    }

    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var areaArray = [Area]()
    private var searchInfoArray = [SearchInfo]()
    private var areaState = AreaState.largeArea
    private let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //初期表示時は復数選択不可
        tableView.allowsMultipleSelection = false
        let nib = UINib(nibName: "SelectAreaTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areaArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectAreaTableViewCell
        cell.setData(areaArray[indexPath.row])
        if areaState == AreaState.smallArea {
            cell.selectionStyle = .none
            //決定ボタンの表示
            self.decisionButton.isHidden = false
            self.decisionButton.layer.cornerRadius = 15
        }else {
            cell.selectionStyle = .default
            //決定ボタンの非表示
            self.decisionButton.isHidden = true
        }
        return cell
    }
    //セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //大エリアの場合
        if areaState == AreaState.largeArea{
            //現在の選択した条件を取得
            let area:Area = Area(code:self.areaArray[indexPath.row].code,name:self.areaArray[indexPath.row].name)
            //大エリアのコードで中エリアを検索
            let params = ["large_area":area.code]
            //選択したデータから中エリアを取得
            API.shared.request(path: .middle_area, params: params, type: MiddleAreaItems.self) { (items) in
                //戻ってきたときに呼ばれる
                //areaArrayを初期化して、取得っしたデータに入れ替える。
                self.areaArray = items.results.middle_area
                //再描画
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
                //状態を中エリアとする
                self.areaState = AreaState.middleArea
            }
            
        } else if areaState == AreaState.middleArea {
            //中エリアの場合
            let area:Area = Area(code:self.areaArray[indexPath.row].code,name:self.areaArray[indexPath.row].name)
            //中エリアのコードで小エリアを検索
            let params = ["middle_area":area.code]
            //選択したデータから小エリアを取得
            API.shared.request(path: .small_area, params: params, type: SmallAreaItems.self) { (items) in
                //戻ってきたときに呼ばれる
                //areaArrayを初期化して、取得っしたデータに入れ替える。
                self.areaArray = items.results.small_area
                
                //再描画
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
                //状態を小エリアとする
                self.areaState = AreaState.smallArea
                
                //小エリアの情報を配列に設定
                for index in 0..<self.areaArray.count{
                    self.setSearchInfo(index)
                }
                //複数選択可
                tableView.allowsMultipleSelection = true
            }
        } else if areaState == AreaState.smallArea {
            //小エリアの場合
            let cell = tableView.cellForRow(at: indexPath)
            searchInfoArray[indexPath.row].setCheckState(check: true)
            searchInfoArray[indexPath.row].setCheckState(check: true)
            cell?.accessoryType = .checkmark //チェック選択
        }
    }
    //セル選択解除時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //小エリアの場合
        if areaState == AreaState.smallArea{
            let cell = tableView.cellForRow(at: indexPath)
            searchInfoArray[indexPath.row].setCheckState(check: false)
            cell?.accessoryType = .none //チェック解除
        }
    }
        
    //検索条件に設定
    private func setSearchInfo(_ index :Int){
        let searchInfo = SearchInfo(id: areaArray[index].code, name: areaArray[index].name, check: false)
        self.searchInfoArray.append(searchInfo)
    }
    //決定ボタン押下時
    @IBAction func searchDecision(_ sender: Any) {
        //検索条件を前の画面に渡す
        let nav  = self.navigationController
        let preVC = nav?.viewControllers[0] as! DetailSearchViewController
        preVC.searchInfoAreaArray = self.searchInfoArray.filter {
            //チェックがついているものだけを渡す
            $0.check == true
        }
        //ルート(DetailSearchViewController)に画面遷移する
        self.navigationController?.popToViewController(navigationController!.viewControllers[0], animated: true)
    }
    
}
