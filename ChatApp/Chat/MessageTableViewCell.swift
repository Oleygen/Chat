//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Den on 2020-09-30.
//  Copyright © 2020 Den. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var leftInsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightInsetCostraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(isMy: Bool, _ message: Message) {
        let inset: CGFloat = 70
        if isMy {
            rightInsetCostraint.constant = inset
        } else {
            leftInsetConstraint.constant = inset
        }
        messageText.text = "asdaldfnaldfnlsnvlasdadfafadfadfsjfnvljdfnvkdjnvdkjfnkvdjnfkv"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
