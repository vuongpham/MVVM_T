//
//  UserCell.swift
//  MVVMAgain
//
//  Created by Vuong on 6/14/19.
//  Copyright © 2019 Vuong. All rights reserved.
//

import UIKit
import SDWebImage

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLb: UILabel!
    @IBOutlet weak var icImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureUserCell(item: UserCellViewModel?) {
        self.userNameLb.text = item?.userName
        self.icImage.sd_setImage(with: URL(string: item?.avatarURL ?? ""))
    }
}
