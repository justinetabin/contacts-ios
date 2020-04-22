//
//  UpdateContactViewModelTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class UpdateContactViewModelTests: XCTestCase {
    
    var sut: UpdateContactViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = UpdateContactViewModel(contactId: "", factory: DependencyWorker(contactsApi: MockContactsStore()))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func test_whenSuccessfullyFetchedContact_thenShouldEnableSave() {
        // given
        let expect = expectation(description: "Wait until setSaveEnable.observe() receives a value")
        expect.expectedFulfillmentCount = 2
        
        // when
        var saveEnables: [Bool] = []
        sut.output.saveEnable.observe(on: self) { (bool) in
            expect.fulfill()
            // first call should disable, second should re-enable
            saveEnables.append(bool)
        }
        sut.input.viewDidLoad.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(saveEnables, [false, true])
    }
    
    func test_whenFailedFetchContact_thenShouldPresentError() {
        // given
        let expect = expectation(description: "Wait until presentableError.observe() receives a value")
        let contactStore = sut.worker.contactsStore as! MockContactsStore
        contactStore.isSuccess = false
        
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
    
    func test_whenFailedUpdateContact_thenShouldPresentError() {
        // given
        let expect = expectation(description: "Wait until presentableError.observe() receives a value")
        let contactStore = sut.worker.contactsStore as! MockContactsStore
        contactStore.isSuccess = false
        
        // when
        var gotMessage: String?
        sut.output.presentableError.observe(on: self) { (message) in
            expect.fulfill()
            gotMessage = message
        }
        sut.input.didTapSave.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotMessage, "Contact not updated")
    }
    
    func test_whenSuccessfullySavedContact_thenShouldReturnUpdatedContact() {
        // given
        let expect = expectation(description: "Wait until didUpdateContact.observe() receives a value")
        expect.expectedFulfillmentCount = 3
        let expectedContact = Contact(_id: "",
                                      firstName: "Justine",
                                      lastName: "Tabin",
                                      email: "justinetabin@mail.com",
                                      phoneNumber: "+639175207732",
                                      createdAt: "",
                                      updatedAt: "")
        
        // when
        sut.input.didEnterFirstName.value = expectedContact.firstName
        sut.input.didEnterLastName.value = expectedContact.lastName
        sut.input.didEnterEmail.value = expectedContact.email
        sut.input.didEnterPhoneNumber.value = expectedContact.phoneNumber
        
        var saveEnables: [Bool] = []
        sut.output.saveEnable.observe(on: self) { (bool) in
            expect.fulfill()
            saveEnables.append(bool)
        }
        
        var gotContact: Contact?
        sut.output.updatedContact.observe(on: self) { (contact) in
            expect.fulfill()
            gotContact = contact
        }
        sut.input.didTapSave.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotContact, expectedContact)
        XCTAssertEqual(saveEnables, [false, true])
    }
    
    func test_whenViewDidLoad_thenShouldReturnTableDataSource() {
        // given
        
        // when
        sut.input.viewDidLoad.value = ()
        
        // then
        XCTAssertEqual(sut.output.displayableSections.value.count, 2)
        XCTAssertEqual(sut.output.displayableSections.value[0].displayableRows.count, 1)
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows.count, 4)
        XCTAssertEqual(sut.output.displayableSections.value[0].displayableRows[0].rowHeight, 200)
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[0].rowHeight, 80)
    }
    
    func test_whenViewDidLoad_thenShouldReturnDisplayablePlaceholder() {
        // given
        
        // when
        sut.input.viewDidLoad.value = ()
        
        // then
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[0].placeholder, "First Name")
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[1].placeholder, "Last Name")
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[2].placeholder, "email")
        XCTAssertEqual(sut.output.displayableSections.value[1].displayableRows[3].placeholder, "mobile")
    }

}
