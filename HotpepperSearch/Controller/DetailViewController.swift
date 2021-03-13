//
//  DetailViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/11.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var url  = String()
    var name = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let requesturl  = URL(string: url) else { return}
        let request = URLRequest(url:requesturl)
        webView.load(request)        
    }

}
