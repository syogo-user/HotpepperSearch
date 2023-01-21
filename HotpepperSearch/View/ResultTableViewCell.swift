//
//  ResultTableViewCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import UIKit
import Nuke

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var shopName: UILabel!

    @IBOutlet weak var shopCatch: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var budget: UILabel! //予算
    @IBOutlet weak var nomiImage: UIImageView!
    @IBOutlet weak var tabeImage: UIImageView!
    @IBOutlet weak var privateRoomImage: UIImageView!
    @IBOutlet weak var noSmorkingImage: UIImageView!
    @IBOutlet weak var kotatsuImage: UIImageView!
    @IBOutlet weak var courseImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ shop: Shop) {
        self.shopName.text = shop.name
        self.shopCatch.text =  shop.catch
        self.address.text = shop.address
        self.budget.text = shop.budget.name
        
        //画像の表示
        if let url = URL(string: shop.photo.mobile.l) {
            Nuke.loadImage(with: url, into: imageView1)
        }
        
        setImageIcon(shop)
    }
    
    private func setImageIcon(_ shop: Shop) {
        //飲み放題
        if shop.free_drink.count == 0 {
            self.nomiImage.image = UIImage(named: "nomiEnable")
        } else {
            if shop.free_drink.hasPrefix("あり") {
                self.nomiImage.image = UIImage(named: "nomi")
            } else {
                self.nomiImage.image = UIImage(named: "nomiEnable")
            }
        }
        //食べ放題
        if shop.free_food.count == 0 {
            self.tabeImage.image = UIImage(named: "tabeEnable")
        } else {
            if shop.free_food.hasPrefix("あり") {
                self.tabeImage.image = UIImage(named: "tabe")
            } else {
                self.tabeImage.image = UIImage(named: "tabeEnable")
            }
        }
        
        //個室
        if shop.private_room.count == 0 {
            self.privateRoomImage.image = UIImage(named: "privateRoomEnable")
        } else {
            if shop.private_room.hasPrefix("あり") {
                self.privateRoomImage.image = UIImage(named: "privateRoom")
            } else {
                self.privateRoomImage.image = UIImage(named: "privateRoomEnable")
            }
        }
        
        //禁煙
        if shop.non_smoking.count == 0 {
            self.noSmorkingImage.image = UIImage(named: "noSmorkingEnable")
        } else {
            if shop.non_smoking.hasPrefix("全面禁煙") || shop.non_smoking.hasPrefix("一部禁煙") {
                self.noSmorkingImage.image = UIImage(named: "noSmorking")
            } else {
                self.noSmorkingImage.image = UIImage(named: "noSmorkingEnable")
            }
        }
        
        //掘りごたつ
        if shop.horigotatsu.count == 0 {
            self.kotatsuImage.image = UIImage(named: "kotatsuEnable")
        } else {
            if shop.horigotatsu.hasPrefix("あり") {
                self.kotatsuImage.image = UIImage(named: "kotatsu")
            } else {
                self.kotatsuImage.image = UIImage(named: "kotatsuEnable")
            }
        }
        
        //コース
        if shop.course.count == 0 {
            self.courseImage.image = UIImage(named: "courseEnable")
        } else {
            if shop.course.hasPrefix("あり") {
                self.courseImage.image = UIImage(named: "course")
            } else {
                self.courseImage.image = UIImage(named: "courseEnable")
            }
        }
    }
}
