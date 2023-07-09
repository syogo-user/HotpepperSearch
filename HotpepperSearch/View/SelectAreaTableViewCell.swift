//
//  SelectAreaTableViewCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/20.
//

import UIKit

class SelectAreaTableViewCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ area: Area) {
        self.title.text = area.name
    }
}
