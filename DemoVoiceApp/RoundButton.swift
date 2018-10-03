//
//  RoundButton.swift
//  EmergencyCall
//
//  Created by Axiom HK 14 on 30/04/2018.
//  Copyright © 2018 Axiom HK 14. All rights reserved.
//

import UIKit
@IBDesignable

class RoundButton: UIButton {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
}



