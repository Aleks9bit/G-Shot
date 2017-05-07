//
// Created by alexey on 5/6/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit

class LeftRightPaddedTextField: UITextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
                x: bounds.origin.x + 20,
                y: bounds.origin.y,
                width: bounds.width - 30,
                height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
                x: bounds.origin.x + 20,
                y: bounds.origin.y,
                width: bounds.width - 30,
                height: bounds.height)
    }

}
