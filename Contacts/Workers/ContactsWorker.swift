//
//  ContactsWorker.swift
//  Contacts
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class ContactsWorker {
    let contactsStore: ContactsStoreProtocol
    
    init(contactsStore: ContactsStoreProtocol) {
        self.contactsStore = contactsStore
    }
    
    func fetchContacts(completion: @escaping ([Contact]) -> Void) {
        self.contactsStore.fetchContacts { (contacts, error) in
            if let contacts = contacts {
                completion(contacts)
            } else {
                completion([])
            }
        }
    }
    
    func groupContacts(contacts: [Contact]) -> [ContactGroup] {
        let sortedContacts = contacts.sorted(by: { (lhs, rhs) -> Bool in
            return (lhs.firstName < rhs.firstName)
        })
        var contactGroups = [ContactGroup]()
        sortedContacts.forEach { (contact) in
            if let initialLetter = contact.firstName.first {
                
                // check if initial letter is already in contact groups
                let existingIndex = contactGroups.firstIndex { (contactGroup) -> Bool in
                    return contactGroup.title.uppercased() == initialLetter.uppercased()
                }
                
                if let index = existingIndex {
                    // append contact in contact group
                    contactGroups[index].contacts.append(contact)
                } else {
                    // create new contact group
                    contactGroups.append(ContactGroup(title: initialLetter.uppercased(), contacts: [contact]))
                }
            }
        }
        return contactGroups
    }
    
    func createContact(contactToCreate: Contact, completion: @escaping (Contact?) -> Void) {
        contactsStore.createContact(contactToCreate: contactToCreate) { (contact, error) in
            completion(contact)
        }
    }
    
    func getContact(contactId: String, completion: @escaping (Contact?) -> Void) {
        contactsStore.getContact(contactId: contactId) { (contact, error) in
            completion(contact)
        }
    }
}

protocol ContactsStoreProtocol {
    func fetchContacts(completion: @escaping ([Contact]?, Error?) -> Void)
    func getContact(contactId: String, completion: @escaping (Contact?, Error?) -> Void)
    func createContact(contactToCreate: Contact, completion: @escaping (Contact?, Error?) -> Void)
    func updateContact(contactToUpdate: Contact, completion: @escaping (Bool?, Error?) -> Void)
    func deleteContact(contactId: String, completion: @escaping (Bool?, Error?) -> Void)
}
