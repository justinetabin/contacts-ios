//
//  Seeds.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
@testable import Contacts

struct Seeds {
    
    struct Contacts {
        
        static var justine = Contact(_id: "1",
                                     firstName: "Justine",
                                     lastName: "Tabin",
                                     email: "justinetabin@email.com",
                                     phoneNumber: "+639111111111",
                                     createdAt: "",
                                     updatedAt: "")
        
        static var skinner = Contact(_id: "2",
                                     firstName: "Skinner",
                                     lastName: "Austin",
                                     email: "skinneraustin@email.com",
                                     phoneNumber: "+639111111112",
                                     createdAt: "",
                                     updatedAt: "")
        
        static var dalton = Contact(_id: "3",
                                    firstName: "Dalton",
                                    lastName: "Hardy",
                                    email: "skinneraustin@email.com",
                                    phoneNumber: "+639111111113",
                                    createdAt: "",
                                    updatedAt: "")
        
        static var collins = Contact(_id: "4",
                                    firstName: "Collins",
                                    lastName: "Moon",
                                    email: "collinsmoon@email.com",
                                    phoneNumber: "+639111111114",
                                    createdAt: "",
                                    updatedAt: "")
        
        static var cathy = Contact(_id: "4",
                                   firstName: "Cathy",
                                   lastName: "Mooney",
                                   email: "cathymooney@email.com",
                                   phoneNumber: "+639111111114",
                                   createdAt: "",
                                   updatedAt: "")
    }
}
