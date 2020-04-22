//
//  UpdateContactViewControllerTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class UpdateContactViewControllerTests: XCTestCase {
    
    var sut: UpdateContactViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dependencyWorker = DependencyWorker(contactsApi: MockContactsStore())
        sut = dependencyWorker.makeUpdateContact(contactId: "")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenDisplayedTable_thenSouldReturnCellForRowTypes() {
        // given
        
        // when
        let avatarCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(item: 0, section: 0))
        let detailCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(item: 0, section: 1))
        
        // then
        XCTAssert(avatarCell is UpdateContactInputAvatarTableViewCell)
        XCTAssert(detailCell is UpdateContactInputDetailTableViewCell)
    }
    
    func test_whenDisplayedTable_thenShouldReturnCellForRowContact() {
        // given
        let displayableSections = sut.viewModel.output.displayableSections
        
        // when
        let firstNameCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? UpdateContactInputDetailTableViewCell
        let lastNameCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 1, section: 1)) as? UpdateContactInputDetailTableViewCell
        let emailCell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 2, section: 1)) as? UpdateContactInputDetailTableViewCell
        let phoneNumber = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 3, section: 1)) as? UpdateContactInputDetailTableViewCell
        
        // then
        XCTAssertEqual(firstNameCell?.placeholderLabel.text, displayableSections.value[1].displayableRows[0].placeholder)
        XCTAssertEqual(lastNameCell?.placeholderLabel.text, displayableSections.value[1].displayableRows[1].placeholder)
        XCTAssertEqual(emailCell?.placeholderLabel.text, displayableSections.value[1].displayableRows[2].placeholder)
        XCTAssertEqual(phoneNumber?.placeholderLabel.text, displayableSections.value[1].displayableRows[3].placeholder)
    }
    
    func test_whenDisplayedTable_thenShouldReturnNumberOfRowsInSection() {
        // given
        let displayableSections = sut.viewModel.output.displayableSections
        
        // when
        let avatarNumberOfRow = sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        let detailsNumberOfRow = sut.tableView(sut.tableView, numberOfRowsInSection: 1)
        
        // then
        XCTAssertEqual(avatarNumberOfRow, displayableSections.value[0].numberOfRows)
        XCTAssertEqual(detailsNumberOfRow, displayableSections.value[1].numberOfRows)
    }
    
    func test_whenDisplayedTable_thenShouldReturnnumberOfSections() {
        // given
        let displayableSections = sut.viewModel.output.displayableSections
        
        // when
        let avatarNumberOfRow = sut.numberOfSections(in: sut.tableView)
        
        // then
        XCTAssertEqual(avatarNumberOfRow, displayableSections.value.count)
    }
    
    func test_whenGotError_thenPresentError() {
        // given
        let expect = expectation(description: "Wait for presentableError.observe() to receive a value")
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // when
        window.makeKeyAndVisible()
        window.rootViewController = sut
        
        sut.view.layoutIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        sut.viewModel.output.presentableError.observe(on: self) { (_) in
            DispatchQueue.main.async {
                expect.fulfill()
            }
        }
        sut.viewModel.output.presentableError.value = ""
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(sut.presentedViewController is UIAlertController)
    }
    
    func test_whenTappedSave_thenShouldPopView() {
        // given
        let expect = expectation(description: "Wait for didUpdateContact.observe() to receive a value")
        let nav = UINavigationController(rootViewController: UIViewController())
        nav.pushViewController(sut, animated: false)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = sut
        
        // when
        sut.viewModel.output.updatedContact.observe(on: self) { (_) in
            DispatchQueue.main.async {
                expect.fulfill()
            }
        }
        sut.didTapSave(button: UIBarButtonItem())
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertFalse(nav.viewControllers.contains(sut))
    }

}
