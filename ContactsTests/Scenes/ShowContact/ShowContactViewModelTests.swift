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
    
    var sut: ShowContactViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ShowContactViewModel(contactId: "", factory: DependencyWorker(contactsApi: MockContactsStore()))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenSuccessfullyFetchedContact_thenShouldReloadData() {
        // given
        let expect = expectation(description: "Wait for displayableSections.observe() to receive a value")
        
        // when
        sut.output.displayableSections.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.input.viewDidLoad.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotEqual(sut.output.displayableContact.fullname.value, "")
        XCTAssertNotEqual(sut.output.displayableContact.email.value, "")
        XCTAssertNotEqual(sut.output.displayableContact.phoneNumber.value, "")
    }
    
    func test_whenFailedFetchedContact_thenShouldReloadData() {
        // given
        let expect = expectation(description: "Wait for presentableError.observe() to receive a value")
        let contactsStore = sut.worker.contactsStore as! MockContactsStore
        contactsStore.isSuccess = false
        
        // when
        var gotMessage: String?
        sut.output.presentableError.observe(on: self) { (message) in
            expect.fulfill()
            gotMessage = message
        }
        sut.input.viewDidLoad.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotMessage, "Contact not found")
    }
    
    func test_whenViewDidLoad_thenShouldReturnTableDataSource() {
        // given
        
        // when
        sut.input.viewDidLoad.value = ()
        
        // then
        XCTAssertEqual(sut.output.displayableSections.value.count, 2)
        XCTAssertEqual(sut.output.displayableSections.value[0].numberOfRows, 1)
        XCTAssertEqual(sut.output.displayableSections.value[1].numberOfRows, 3)
        XCTAssertEqual(sut.output.displayableSections.value[0].displayableRows[0].rowHeight, 200)
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[0].rowHeight, 80)
    }
    
    func test_whenViewDidLoad_thenShouldReturnDisplayablePlaceholder() {
        // given
        
        // when
        sut.input.viewDidLoad.value = ()
        
        // then
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[0].placeholder, "full name")
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[1].placeholder, "email")
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[2].placeholder, "mobile")
    }

}
