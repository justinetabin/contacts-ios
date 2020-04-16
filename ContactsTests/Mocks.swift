//
//  Mocks.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
@testable import Contacts

class MockContactsStore: ContactsStoreProtocol {
    var contacts = [
        Seeds.Contacts.justine,
        Seeds.Contacts.skinner,
        Seeds.Contacts.dalton,
        Seeds.Contacts.collins,
        Seeds.Contacts.cathy
    ]
    var isSuccess = true
    
    func fetchContacts(completion: @escaping ([Contact]?, Error?) -> Void) {
        if isSuccess {
            completion(contacts, nil)
        } else {
            completion(nil, NSError(domain: "", code: 400))
        }
    }
    
    func getContact(contactId: String, completion: @escaping (Contact?, Error?) -> Void) {
        if isSuccess {
            completion(contacts[0], nil)
        } else {
            completion(nil, NSError(domain: "", code: 400))
        }
    }
    
    func createContact(contactToCreate: Contact, completion: @escaping (Contact?, Error?) -> Void) {
        if isSuccess {
            completion(contactToCreate, nil)
        } else {
            completion(nil, NSError(domain: "", code: 400))
        }
    }
    
    func updateContact(contactToUpdate: Contact, completion: @escaping (Bool?, Error?) -> Void) {
        if isSuccess {
            completion(true, nil)
        } else {
            completion(nil, NSError(domain: "", code: 400))
        }
    }
    
    func deleteContact(contactId: String, completion: @escaping (Bool?, Error?) -> Void) {
        if isSuccess {
            completion(true, nil)
        } else {
            completion(nil, NSError(domain: "", code: 400))
        }
    }
    
}
