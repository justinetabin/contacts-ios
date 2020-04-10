//
//  Contact.swift
//  Contacts
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

struct Contact: Codable, Equatable {
    var _id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var createdAt: String
    var updatedAt: String
}
