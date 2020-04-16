//
//  ObservableTextField.swift
//  Contacts
//
//  Created by Justine Tabin on 4/13/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ObservableTextField: UITextField {
    
    var observable = Observable("") {
        didSet {
            editingChange(textField: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(editingChange), for: .editingChanged)
    }
    
    @objc func editingChange(textField: UITextField) {
        if let text = textField.text {
            observable.value = text
        }
    }
}
