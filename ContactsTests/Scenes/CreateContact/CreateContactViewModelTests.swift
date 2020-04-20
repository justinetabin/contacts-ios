//
//  CreateContactViewModelTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/14/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class CreateContactViewModelTests: XCTestCase {
    
    var sut: CreateContactViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CreateContactViewModel(factory: DependencyWorker(contactsApi: MockContactsStore()))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenSuccessToSaveContact_thenShouldReturnCreatedContact() {
        // given
        let expect = expectation(description: "Wait until didCreateContact.observe() receives a value")
        let firstName = "Justine"
        let lastName = "Tabin"
        let email = "justinetabin@emai.com"
        let phoneNumber = "+639171111111"
        
        // when
        sut.input.didEnterFirstName.value = firstName
        sut.input.didEnterLastName.value = lastName
        sut.input.didEnterEmail.value = email
        sut.input.didEnterPhoneNumber.value = phoneNumber
        var createdContact: Contact?
        sut.input.didCreateContact.observe(on: self) { (contact) in
            expect.fulfill()
            createdContact = contact
        }
        sut.input.didTapSave.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNotNil(createdContact)
        XCTAssertEqual(createdContact?.firstName, firstName)
        XCTAssertEqual(createdContact?.lastName, lastName)
        XCTAssertEqual(createdContact?.email, email)
        XCTAssertEqual(createdContact?.phoneNumber, phoneNumber)
    }
    
    func test_whenFailedToSaveContact_thenShouldReturn() {
        // given
        let expect = expectation(description: "Wait for presentableError.observe() to receive a value")
        let contactStore = sut.worker.contactsStore as! MockContactsStore
        contactStore.isSuccess = false
        let expectedErrorMessage = "Contact not created"
        
        // when
        var presentedErrorMessage: String?
        sut.output.presentableError.observe(on: self) { (message) in
            expect.fulfill()
            presentedErrorMessage = message
        }
        sut.input.didTapSave.value = ()
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(presentedErrorMessage, expectedErrorMessage)
    }
    
    func test_whenDisplayedTable_thenShouldProvideTableDataSource() {
        // given
        
        // when
        
        // then
        XCTAssertEqual(sut.output.displayableSections, [.heading, .detail])
        XCTAssertEqual(sut.output.numberOfSections, 2)
        sut.output.displayableSections.forEach { (section) in
            switch section {
            case .heading:
                XCTAssertEqual(section.displayableRows, [.avatar])
                XCTAssertEqual(sut.output.numberOfRowsInSection(section: section.rawValue), 1)
                section.displayableRows.enumerated().forEach { (index, row) in
                    XCTAssertEqual(sut.output.heightForRowInSection(section: section.rawValue, row: index), 200)
                }
            case .detail:
                XCTAssertEqual(section.displayableRows, [.firstName, .lastName, .email, .phoneNumber])
                XCTAssertEqual(sut.output.numberOfRowsInSection(section: section.rawValue), 4)
                section.displayableRows.enumerated().forEach { (index, row) in
                    XCTAssertEqual(sut.output.heightForRowInSection(section: section.rawValue, row: index), 80)
                }
            }
            
            section.displayableRows.forEach { (row) in
                switch row {
                case .avatar: XCTAssertEqual(row.placeholder, "")
                case .firstName: XCTAssertEqual(row.placeholder, "First Name")
                case .lastName: XCTAssertEqual(row.placeholder, "Last Name")
                case .email: XCTAssertEqual(row.placeholder, "email")
                case .phoneNumber: XCTAssertEqual(row.placeholder, "mobile")
                }
            }
        }
    }

}
