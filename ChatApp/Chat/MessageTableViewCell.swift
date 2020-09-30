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
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftInsetConstraint.constant = 8
        rightInsetCostraint.constant = 8
    }
    
    func configureCell(isMy: Bool, _ message: Message) {
        selectionStyle = UITableViewCell.SelectionStyle.none
        isUserInteractionEnabled = false
        let inset: CGFloat = 70
        if isMy {
            usernameLabel.textAlignment = .right
            leftInsetConstraint.constant = inset
            messageText.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.7)
        } else {
            rightInsetCostraint.constant = inset
            messageText.backgroundColor = UIColor.systemBlue
        }
        messageText.layer.cornerRadius = 8
        messageText.clipsToBounds = true
        messageText.text = message.message
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
