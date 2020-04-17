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
    
    var sut: ShowContactViewModelType!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dependencyWorker = DependencyWorker(contactsApi: MockContactsStore())
        sut = ShowContactViewModel(contactId: "", factory: dependencyWorker)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}
