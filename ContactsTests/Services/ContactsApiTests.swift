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
        waitForExpectations(timeout: 10.0, handler: nil)
        XCTAssertNotNil(fetchedContacts)
        XCTAssertNil(gotError)
    }

}
