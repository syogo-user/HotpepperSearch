//
//  SearchConditionCell.swift
//  HotpepperSearch
//
//  Created by 小野寺祥吾 on 2021/03/14.
//

import UIKit
class SearchConditionCell: UITableViewCell {


    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var conditionValue: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
    }
    
    func setData(_ searchCondition :SerachCondition){
        self.title.text = searchCondition.title
        self.conditionValue.text = searchCondition.conditionValue ?? ""
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
