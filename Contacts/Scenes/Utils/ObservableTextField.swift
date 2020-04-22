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
    
    var observable: Observable<String>? {
        didSet {
            text = observable?.value
            observable?.observe(on: self) { [weak self] (text) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.text = text
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(editingChange), for: .editingChanged)
    }
    
    @objc func editingChange(textField: UITextField) {
        if let text = textField.text {
            observable?.value = text
        }
    }
}
