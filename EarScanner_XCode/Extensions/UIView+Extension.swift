//
//  UIView+Extension.swift
//  EarScanner_XCode
//
//  Created by Eliza Fury on 12/9/21.
//

import UIKit

extension UIView {
    func rounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
