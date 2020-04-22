//
//  ViewModelType.swift
//  Contacts
//
//  Created by Justine Tabin on 4/22/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
