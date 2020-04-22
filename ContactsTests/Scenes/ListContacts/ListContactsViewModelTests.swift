//
//  ListContactsViewModelTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ListContactsViewModelTests: XCTestCase {
    
    var sut: ListContactsViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ListContactsViewModel(factory: DependencyWorker(contactsApi: MockContactsStore()))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_whenViewDidLoad_thenShouldDisplayContacts() {
        // given
        let expect = expectation(description: "Wait for displayedContacts.observe() to receive a value")
        
        // when
        sut.output.displayableContacts.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.input.viewDidLoad.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(sut.output.displayableContacts.value.count, 4)
        XCTAssertEqual(sut.output.sectionIndexTitles.value, ["C", "D", "J", "S"])
        ["C", "D", "J", "S"].enumerated().forEach { (offset, char) in
            XCTAssertEqual(sut.output.titleForHeader.value[offset], char)
        }
    }
    
    func test_whenCreatedContact_thenShouldDisplayContact() {
        // given
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        let contactToCreate = Seeds.Contacts.cathy
        
        // when
        sut.output.displayableContacts.observe(on: self) { (_) in
            expect.fulfill()
        }
        
        var gotContact: Contact?
        sut.worker.createContact(contactToCreate: contactToCreate) { (contact) in
            expect.fulfill()
            gotContact = contact
        }
        
        var displayedContact = false
        sut.output.displayableContacts.value.forEach { (section) in
            section.forEach { (row) in
                if let contact = gotContact {
                    displayedContact = row.fullname == "\(contact.firstName) \(contact.lastName)"
                }
            }
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(displayedContact)
    }
    
    func test_whenUpdatedContact_thenShouldUpdateDisplayedContact() {
        // given
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        var contactToUpdate = Seeds.Contacts.cathy
        sut.contacts = [contactToUpdate]
        contactToUpdate.firstName = "Momon"
        
        // when
        sut.output.displayableContacts.observe(on: self) { (_) in
            expect.fulfill()
        }
        
        var gotContact: Contact?
        sut.worker.updateContact(contactToUpdate: contactToUpdate) { (contact) in
            expect.fulfill()
            gotContact = contact
        }
        
        var displayedContact = false
        sut.output.displayableContacts.value.forEach { (section) in
            section.forEach { (row) in
                if let contact = gotContact {
                    displayedContact = row.fullname == "\(contact.firstName) \(contact.lastName)"
                }
            }
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(displayedContact)
    }
}
