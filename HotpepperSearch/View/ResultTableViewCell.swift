//
//  ResultTableViewCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import UIKit
import Nuke
class ResultTableViewCell: UITableViewCell{

    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var shopCatch: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var budget: UILabel! //予算
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func setData(_ shop:Shop){
        self.shopName.text = shop.name
        self.genre.text = shop.genre.name
        self.shopCatch.text =  shop.catch
        self.address.text = shop.address
        self.budget.text = shop.budget.name
        
        //画像の表示
        if let url = URL(string: shop.photo.mobile.l){
            Nuke.loadImage(with: url, into: imageView1)
        }
    }
    
}
