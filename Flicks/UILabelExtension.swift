//
//  UILabelExtension.swift
//  Flicks
//
//  Created by Akash Ungarala on 10/17/16.
//  Copyright © 2016 Akash Ungarala. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func requiredHeight() -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0 , y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.font
        label.sizeToFit()
        return label.frame.height
    }
}
