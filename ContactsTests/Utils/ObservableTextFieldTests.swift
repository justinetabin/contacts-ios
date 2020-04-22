//
//  ObservableTextFieldTests.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/22/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ObservableTextFieldTests: XCTestCase {
    
    var sut: ObservableTextField!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = ObservableTextField()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_whenObservableValueChanged_thenTextShouldChange() {
        // given
        let expect = expectation(description: "Wait for main thread")
        sut.observable = Observable("")
        
        // when
        sut.observable?.value = "Hello"
        var gotText: String?
        DispatchQueue.main.async {
            expect.fulfill()
            gotText = self.sut.text
        }
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(gotText, "Hello")
    }
    
    func test_whenEditingChanged_thenObservableShouldReceiveValue() {
        // given
        let expect = expectation(description: "Wait for observe() to receive a value")
        sut.observable = Observable("")
        
        // when
        sut.observable?.observe(on: self) { (_) in
            expect.fulfill()
        }
        sut.editingChange(textField: sut)
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
    }

}
