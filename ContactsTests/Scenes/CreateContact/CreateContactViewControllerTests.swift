//
//  CreateContactsViewControllerTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/14/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class CreateContactsViewControllerTests: XCTestCase {
    
    var sut: CreateContactViewController!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dependencyWorker = DependencyWorker(contactsApi: MockContactsStore())
        sut = dependencyWorker.makeCreateContact()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenDisplayedTable_thenShouldReturnTableDataSource() {
        // given
        
        // when
        
        // then
        XCTAssertEqual(sut.tableView(sut.tableView, numberOfRowsInSection: 0), 1)
        XCTAssertEqual(sut.numberOfSections(in: sut.tableView), 2)
        
        CreateContactViewModel.TableSection.allCases.enumerated().forEach { (offsetSection, section) in
            section.displayableRows.enumerated().forEach { (offsetRow, row) in
                let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: offsetRow, section: offsetSection))
                switch row {
                case .avatar:
                    XCTAssert(cell is CreateContactInputAvatarTableViewCell)
                case .firstName, .lastName, .email, .phoneNumber:
                    XCTAssert(cell is CreateContactInputDetailTableViewCell)
                }
            }
        }
    }
    
    func test_whenCreatedContact_thenShouldPop() {
        // given
        let expect = expectation(description: "Wait until UI is finished")
        let nav = UINavigationController(rootViewController: UIViewController())
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // when
        
        /*
         * Make it popable
         */
        nav.pushViewController(sut, animated: false)
        
        /*
         * Configure window
         */
        window.makeKeyAndVisible()
        window.rootViewController = sut
        
        sut.view.layoutIfNeeded()
        sut.viewModel.input.didCreateContact.value = Seeds.Contacts.cathy
        let previousVCCount = nav.viewControllers.count
        var currentVCCount = nav.viewControllers.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expect.fulfill()
            currentVCCount = nav.viewControllers.count
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertGreaterThan(previousVCCount, currentVCCount)
    }
    
    func test_whenDidSave_thenShouldReEnableSaveButton() {
        // given
        let expect = expectation(description: "Wait for didCreateContact.observe() to receive a value")
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        // when
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        sut.view.layoutIfNeeded()
        var saveIsEnabledBeforeSave: Bool? = true
        var saveIsEnabledAfterSave: Bool? = false
        var saveIsEnabledOnCreated: Bool? = false
        
        saveIsEnabledBeforeSave = sut.navigationItem.rightBarButtonItem?.isEnabled
        sut.viewModel.input.didCreateContact.observe(on: self) { [unowned self] (_) in
            expect.fulfill()
            saveIsEnabledOnCreated = self.sut.navigationItem.rightBarButtonItem?.isEnabled
        }
        sut.didTapSave()
        saveIsEnabledAfterSave = sut.navigationItem.rightBarButtonItem?.isEnabled
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(saveIsEnabledBeforeSave, true)
        XCTAssertEqual(saveIsEnabledAfterSave, false)
        XCTAssertEqual(saveIsEnabledOnCreated, true)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                expect.fulfill()
            }
        }
        sut.viewModel.output.presentableError.value = ""
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssert(sut.presentedViewController is UIAlertController)
    }
}
