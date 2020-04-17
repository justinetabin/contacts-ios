//
//  ShowContactAvatarTableViewCell.swift
//  Contacts
//
//  Created by Justine Tabin on 4/16/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ShowContactAvatarTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.backgroundColor = UIColor.systemGray3
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
}
