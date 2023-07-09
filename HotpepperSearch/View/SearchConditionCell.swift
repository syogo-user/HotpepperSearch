//
//  SearchConditionCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//

import UIKit

class SearchConditionCell: UITableViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var conditionValue: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ searchCondition: SerachCondition) {
        self.title.text = searchCondition.title
        self.conditionValue.text = searchCondition.conditionValue ?? ""
        self.iconImageView.image = UIImage(named: searchCondition.imageName)
    }
}
