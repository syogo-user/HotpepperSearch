//
//  ResultTableViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//
//
import UIKit

class ResultTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var url = ""
    var shopDataArray :[Shop] = []
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "cellId"
    private let seguId = "shopWebVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shopDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.setData(shopDataArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.url = self.shopDataArray[indexPath.row].urls.pc
        self.performSegue(withIdentifier: self.seguId , sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopWebVC" {
            guard let shopWebVC = segue.destination as? DetailViewController else {return}
            shopWebVC.url  = url
        }
    }
}
