//
//  ShowContactViewModelTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ShowContactViewModelTests: XCTestCase {
    
    var contactStore: MockContactsStore!
    var sut: ShowContactViewModelType!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        contactStore = MockContactsStore()
        let dependencyWorker = DependencyWorker(contactsApi: contactStore)
        sut = ShowContactViewModel(contactId: "", factory: dependencyWorker)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenSuccessfullyFetchedContact_thenShouldReloadData() {
        // given
        let expect = expectation(description: "Wait for reloadData.observe() to receive a value")
        
        // when
        sut.input.reloadData.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.input.fetchContact.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotEqual(sut.output.displayableContact.fullname.value, "")
        XCTAssertNotEqual(sut.output.displayableContact.email.value, "")
        XCTAssertNotEqual(sut.output.displayableContact.phoneNumber.value, "")
    }
    
    func test_whenFailedFetchedContact_thenShouldReloadData() {
        // given
        let expect = expectation(description: "Wait for presentableError.observe() to receive a value")
        
        // when
        var gotMessage: String?
        sut.output.presentableError.observe(on: self) { (message) in
            expect.fulfill()
            gotMessage = message
        }
        contactStore.isSuccess = false
        sut.input.fetchContact.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotMessage, "Contact not found")
    }
    
    func test_whenInit_thenShouldReturnTableDataSource() {
        // given
        
        // when
        
        // then
        XCTAssertEqual(sut.output.numberOfSections, 2)
        XCTAssertEqual(sut.output.numberOfRowsInSection(section: 0), 1)
        XCTAssertEqual(sut.output.numberOfRowsInSection(section: 1), 3)
        XCTAssertEqual(sut.output.heightForRowInSection(section: 0, row: 0), 200)
        XCTAssertEqual(sut.output.heightForRowInSection(section: 1, row: 0), 80)
    }
    
    func test_whenInit_thenShouldReturnDisplayablePlaceholder() {
        // given
        
        // when
        
        // then
        XCTAssertEqual(sut.output.displayableSections[1].displayableRows[0].placeholder, "full name")
        XCTAssertEqual(sut.output.displayableSections[1].displayableRows[1].placeholder, "email")
        XCTAssertEqual(sut.output.displayableSections[1].displayableRows[2].placeholder, "mobile")
    }

}
