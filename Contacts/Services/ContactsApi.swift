//
//  ContactsApi.swift
//  Contacts
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class ContactsApi: ContactsStoreProtocol {
    private var httpClient: HTTPClient
    
    init() {
        httpClient = HTTPClient(baseUrl: CONSTANTS_API_BASE_URL)
    }
    
    func fetchContacts(completion: @escaping ([Contact]?, Error?) -> Void) {
        let request = HTTPClient.Request(path: "/contacts", method: .GET)
        httpClient.dataTask(type: [Contact].self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
    func getContact(contactId: String, completion: @escaping (Contact?, Error?) -> Void) {
        let request = HTTPClient.Request(path: "/contacts/\(contactId)", method: .GET)
        httpClient.dataTask(type: Contact.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
    func createContact(contactToCreate: Contact, completion: @escaping (Contact?, Error?) -> Void) {
        var request = HTTPClient.Request(path: "/contacts", method: .POST)
        request.params = [
            "firstName": contactToCreate.firstName,
            "lastName": contactToCreate.lastName,
            "email": contactToCreate.email,
            "phoneNumber": contactToCreate.phoneNumber
        ]
        httpClient.dataTask(type: Contact.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
    func updateContact(contactToUpdate: Contact, completion: @escaping (Contact?, Error?) -> Void) {
        var request = HTTPClient.Request(path: "/contacts/\(contactToUpdate._id)", method: .PUT)
        request.params = [
            "firstName": contactToUpdate.firstName,
            "lastName": contactToUpdate.lastName,
            "email": contactToUpdate.email,
            "phoneNumber": contactToUpdate.phoneNumber
        ]
        httpClient.dataTask(type: Contact.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
    func deleteContact(contactId: String, completion: @escaping (Bool?, Error?) -> Void) {
        let request = HTTPClient.Request(path: "/contacts/\(contactId)", method: .DELETE)
        httpClient.dataTask(type: Bool.self, request: request) { (response) in
            completion(response.body, response.error)
        }
    }
    
}
