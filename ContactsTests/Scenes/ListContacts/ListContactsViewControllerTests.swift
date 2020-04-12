//
//  ListContactsViewControllerTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ListContactsViewControllerTests: XCTestCase {
    
    var sut: ListContactsViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dependencyWorker = DependencyWorker(contactsApi: MockContactsStore())
        sut = dependencyWorker.makeListContacts()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenViewDidLoad_thenShouldDisplayTableView() {
        // given
        let expect = expectation(description: "Wait for reloadData() to receive value")
        
        // when
        sut.viewModel.input.reloadData.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.view.layoutIfNeeded()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 2)
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 1), 1)
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 2), 1)
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 3), 1)
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 4)
        XCTAssertEqual(sut.tableView(sut.tableView, titleForHeaderInSection: 0), "C")
        XCTAssertEqual(sut.tableView(sut.tableView, titleForHeaderInSection: 1), "D")
        XCTAssertEqual(sut.tableView(sut.tableView, titleForHeaderInSection: 2), "J")
        XCTAssertEqual(sut.tableView(sut.tableView, titleForHeaderInSection: 3), "S")
        XCTAssertEqual(sut.sectionIndexTitles(for: sut.tableView), ["C", "D", "J", "S"])
    }

}
