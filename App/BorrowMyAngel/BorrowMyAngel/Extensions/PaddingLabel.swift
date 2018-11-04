//
//  PaddingUILabel.swift
//  BorrowMyAngel
//
//  Created by dev1 on 11/3/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit
@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
}
