//
//  DesignableView.swift
//  EarScanner_XCode
//  Flags that allow more editing capabilities with the storyboards
//  Created by Eliza Fury on 5/8/21.
//

//import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var shadowColour: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColour.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}
