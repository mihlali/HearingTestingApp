//
//  CustomButton.swift
//  HearXProject
//
//  Created by Mihlali Mazomba on 2023/03/05.
//

import UIKit
import Foundation

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var buttonColor: UIColor = .blue {
        didSet {
            self.backgroundColor = buttonColor
        }
    }
    
    @IBInspectable var textColor: UIColor = .white {
        didSet {
            self.setTitleColor(textColor, for: .normal)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
           self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var buttonText: String = "Button" {
        didSet {
            self.titleLabel?.font =  .systemFont(ofSize: 19.0, weight: .regular)
            self.setTitle(buttonText, for: .normal)
        }
    }
}
