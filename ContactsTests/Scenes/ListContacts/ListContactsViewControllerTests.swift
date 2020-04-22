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
    
    var nav: UINavigationController!
    var sut: ListContactsViewController!
    var window: UIWindow!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dependencyWorker = DependencyWorker(contactsApi: MockContactsStore())
        sut = dependencyWorker.makeListContacts()
        nav = UINavigationController(rootViewController: sut)
        window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenViewDidLoad_thenShouldDisplayTableView() {
        // given
        let expect = expectation(description: "Wait for displayedContacts.observe() to receive a value")
        
        // when
        sut.viewModel.output.displayableContacts.observe(on: self) { (_) in
            expect.fulfill()
        }
        window.makeKeyAndVisible()
        sut.view.layoutIfNeeded()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ListContactsTableViewCell
        XCTAssertEqual(cell.fullnameLabel.text, "Cathy Mooney")
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
    
    func test_whenTappedAddContactButton_thenShouldPushAddContacts() {
        // given
        let expect = expectation(description: "Wait for UI thread to finish")
        
        // when
        window.makeKeyAndVisible()
        sut.didTapAdd()
        
        var vcStacks: Int?
        DispatchQueue.main.async {
            expect.fulfill()
            vcStacks = self.sut.navigationController?.viewControllers.count
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(vcStacks, 2)
    }
    
    func test_whenDidSelectRow_thenShouldPushShowContact() {
        // given
        let expect = expectation(description: "")
        
        // when
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        var topViewController: UIViewController?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expect.fulfill()
            topViewController = self.nav.topViewController
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(topViewController is ShowContactViewController)
    }

}
