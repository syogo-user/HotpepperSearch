//
//  SelectTableViewCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/17.
//

import UIKit

class SelectTableViewCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data:Genre ) {
        self.title.text = data.name
    }
}
