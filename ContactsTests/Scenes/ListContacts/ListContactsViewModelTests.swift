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
    
    func test_whenViewDidLoad_thenShouldDisplayContacts() {
        // given
        let expect = expectation(description: "Wait for displayedContacts.observe() to receive a value")
        
        // when
        sut.output.displayedContacts.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.input.viewDidLoad.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(sut.output.displayedContacts.value.count, 4)
        XCTAssertEqual(sut.output.sectionIndexTitles, ["C", "D", "J", "S"])
        XCTAssertEqual(sut.output.titleForHeaderInSection, ["C", "D", "J", "S"])
    }
}
