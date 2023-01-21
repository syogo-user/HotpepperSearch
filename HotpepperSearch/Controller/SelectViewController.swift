//
//  SelectTableViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/17.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var decisionButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var genreArray = [Genre]()

    private let cellId = "cellId"
    private var searchInfoArray = [SearchInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self        
        //復数選択可
        tableView.allowsMultipleSelection = true
        decisionButton.layer.cornerRadius = 15
        let nib = UINib(nibName: "SelectTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectTableViewCell
        cell.setData(genreArray[indexPath.row])
        cell.selectionStyle = .none
        //検索条件を設定
        self.setSearchInfo(indexPath.row)
        return cell
    }
    
    //セル選択時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        searchInfoArray[indexPath.row].setCheckState(check: true)
        cell?.accessoryType = .checkmark //チェック選択
    }
    
    //セル選択解除時
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        searchInfoArray[indexPath.row].setCheckState(check: false)
        cell?.accessoryType = .none //チェック解除
    }
        
    //検索条件に設定
    private func setSearchInfo(_ index: Int) {
        let searchInfo = SearchInfo(id: genreArray[index].code, name: genreArray[index].name, check: false)
        self.searchInfoArray.append(searchInfo)
    }
    
    //決定ボタン押下時
    @IBAction func searchDecision(_ sender: Any) {
        //検索条件を前の画面に渡す
        guard let nav = self.navigationController else { return }
        guard let preVC = nav.viewControllers[(nav.viewControllers.count) - 2] as? DetailSearchViewController else { return }
        preVC.searchInfoGenleArray = self.searchInfoArray.filter {
            //チェックがついているものだけを渡す
            $0.check == true
        }
        //前の画面に画面遷移する
        self.navigationController?.popViewController(animated: true)
    }
}
