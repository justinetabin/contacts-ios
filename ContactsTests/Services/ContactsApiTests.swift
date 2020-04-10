//
//  ContactsApiTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsApiTests: XCTestCase {
    
    var sut: ContactsApi!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = ContactsApi()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_whenFetchedContacts_thenShouldReturnContacts_noError() {
        // given
        let expect = expectation(description: "Wait for fetchContacts() to return")
        
        // when
        var fetchedContacts: [Contact]?
        var gotError: Error?
        sut.fetchContacts { (contacts, error) in
            expect.fulfill()
            fetchedContacts = contacts
            gotError = error
        }
        
        // then
        waitForExpectations(timeout: 60.0, handler: nil)
        XCTAssertNotNil(fetchedContacts)
        XCTAssertNil(gotError)
    }
    
    func test_whenCreatedContact_gotContact_updatedContact_deletedContact_thenShouldReturn_noErrors() {
        // given
        let expect = expectation(description: "Wait for createContact() to return")
        expect.expectedFulfillmentCount = 3
        let contactToCreate = Contact(_id: "",
                                      firstName: "Test",
                                      lastName: "Test",
                                      email: "test@test.com",
                                      phoneNumber: "+11111111111",
                                      createdAt: "",
                                      updatedAt: "")
        
        // when
        var createdContact: Contact?
        var gotCreateError: Error?
        
        var gotContact: Contact?
        var gotContactError: Error?
        
        var contactUpdated: Bool?
        var gotUpdateError: Error?
        
        var contactDeleted: Bool?
        var gotDeleteError: Error?
        sut.createContact(contactToCreate: contactToCreate) { (contact, error) in
            expect.fulfill()
            createdContact = contact
            gotCreateError = error
            
            if let contact = contact {
                
                self.sut.getContact(contactId: contact._id) { (contact, error) in
                    gotContact = contact
                    gotContactError = error
                }
                
                self.sut.updateContact(contactToUpdate: contact) { (bool, error) in
                    expect.fulfill()
                    contactUpdated = bool
                    gotUpdateError = error
                    
                    self.sut.deleteContact(contactId: contact._id) { (bool, error) in
                        expect.fulfill()
                        contactDeleted = bool
                        gotDeleteError = error
                    }
                }
            }
        }
        
        // then
        waitForExpectations(timeout: 60.0, handler: nil)
        
        XCTAssertNotNil(createdContact)
        XCTAssertNil(gotCreateError)
        
        XCTAssertNotNil(gotContact)
        XCTAssertNil(gotContactError)
        
        XCTAssertNotNil(contactUpdated)
        XCTAssertTrue(contactUpdated ?? false)
        XCTAssertNil(gotUpdateError)
        
        XCTAssertNotNil(contactDeleted)
        XCTAssertTrue(contactDeleted ?? false)
        XCTAssertNil(gotDeleteError)
    }

}
