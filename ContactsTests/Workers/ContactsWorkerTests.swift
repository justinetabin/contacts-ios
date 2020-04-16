//
//  ContactsWorkerTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsWorkerTests: XCTestCase {
    
    var contactStore: MockContactsStore!
    var sut: ContactsWorker!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        contactStore = MockContactsStore()
        sut = ContactsWorker(contactsStore: contactStore)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenFetchedContacts_thenShouldReturnContacts() {
        // given
        let expect = expectation(description: "Wait for fetchContacts() to finish")
        let expectedContacts = contactStore.contacts
        
        // when
        var fetchedContacts: [Contact]?
        sut.fetchContacts { (contacts) in
            expect.fulfill()
            fetchedContacts = contacts
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(fetchedContacts, expectedContacts)
    }
    
    func test_whenFailedFetchContacts_thenShouldReturnEmpty() {
        // given
        let expect = expectation(description: "Wait for fetchContacts() to finish")
        let expectedContacts = [Contact]()
        contactStore.isSuccess = false
        
        // when
        var fetchedContacts: [Contact]?
        sut.fetchContacts { (contacts) in
            expect.fulfill()
            fetchedContacts = contacts
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(fetchedContacts, expectedContacts)
    }
    
    func test_whenGroupedContacts_thenShouldReturnContactGroups() {
        // given
        let givenContacts = [
            Seeds.Contacts.justine,
            Seeds.Contacts.dalton,
            Seeds.Contacts.collins,
            Seeds.Contacts.cathy,
            Seeds.Contacts.skinner
        ]
        let expectedContactGroups = [
            ContactGroup(title: "C", contacts: [
                Seeds.Contacts.cathy,
                Seeds.Contacts.collins
            ]),
            ContactGroup(title: "D", contacts: [
                Seeds.Contacts.dalton
            ]),
            ContactGroup(title: "J", contacts: [
                Seeds.Contacts.justine
            ]),
            ContactGroup(title: "S", contacts: [
                Seeds.Contacts.skinner
            ])
        ]
        
        // when
        let groupedContacts = sut.groupContacts(contacts: givenContacts)
        
        // then
        XCTAssertEqual(groupedContacts, expectedContactGroups)
    }
    
    func test_whenCreatedContact_thenShouldReturnContactCreated() {
        // given
        let expect = expectation(description: "Wait for createContact() to return")
        let expectedContact = contactStore.contacts[0]
        
        // when
        var createdContact: Contact?
        sut.createContact(contactToCreate: expectedContact) { (contact) in
            expect.fulfill()
            createdContact = contact
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(createdContact, expectedContact)
    }

}
