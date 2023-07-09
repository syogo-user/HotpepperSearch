//
//  DetailViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/11.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    
    var url  = String()
    var name = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let requestUrl  = URL(string: url) else { return }
        self.navigationController?.navigationBar.topItem?.title = ""
        let request = URLRequest(url:requestUrl)
        webView.load(request)        
    }
}
