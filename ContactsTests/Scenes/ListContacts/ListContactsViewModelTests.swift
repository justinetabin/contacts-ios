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
    }
    
    func test_whenInputFetchedContacts_thenShouldMatchOutputs() {
        // given
        
        // when
        sut.input.fetchContacts.value = ()
        
        // then
        XCTAssertEqual(sut.output.displayedContacts.count, 4)
        XCTAssertEqual(sut.output.numberOfSections, 4)
        XCTAssertEqual(sut.output.numberOfRowsInSection[0], 2)
        XCTAssertEqual(sut.output.numberOfRowsInSection[1], 1)
        XCTAssertEqual(sut.output.numberOfRowsInSection[2], 1)
        XCTAssertEqual(sut.output.numberOfRowsInSection[3], 1)
        XCTAssertEqual(sut.output.sectionIndexTitles, ["C", "D", "J", "S"])
        XCTAssertEqual(sut.output.titleForHeaderInSection, ["C", "D", "J", "S"])
    }
    
    func test_whenInputFetchedContacts_thenShouldReloadData() {
        // given
        let expect = expectation(description: "Wait for reloadData() to receive value")
        
        // when
        var reloadedData = false
        sut.input.reloadData.observe(on: self) { (_) in
            expect.fulfill()
            reloadedData = true
        }
        sut.input.fetchContacts.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(reloadedData)
    }

    func test_whenCreatedAContact_thenShouldDisplayContact() {
        // given
        let expect = expectation(description: "Wait for reloadData.observe() to receive a value")
        let contactsStore = sut.worker.contactsStore as! MockContactsStore
        let expectedContact = contactsStore.contacts[0]
        
        // when
        sut.input.reloadData.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.input.didCreateContact.value = expectedContact
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        sut.output.displayedContacts.forEach { (displayedContact) in
            let insertedContact = displayedContact.first { (displayedContact) -> Bool in
                return displayedContact.fullname == "\(expectedContact.firstName) \(expectedContact.lastName)"
            }
            XCTAssertNotNil(insertedContact)
        }
    }
}
