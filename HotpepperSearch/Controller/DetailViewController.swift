//
//  DetailViewController.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/11.
//

import UIKit
import WebKit
import SDWebImage
class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: WKWebView!
    
    var url  = String()
    var name = String()
    var imageURLString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: URL(string:imageURLString))
        let request = URLRequest(url:URL(string: url)!)
        webView.load(request)        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
