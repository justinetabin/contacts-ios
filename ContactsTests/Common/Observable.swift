//
//  Observable.swift
//  ContactsTests
//
//  Created by Justine Tabin on 4/10/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import XCTest
@testable import Contacts

class ObservableTests: XCTestCase {
    
    var sut: Observable<String>!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = Observable("")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut.remove(observer: self)
    }
    
    func test_whenObserved_GivenValue_thenShouldReturnValues() {
        // given
        let expect = expectation(description: "Wait for observe() to return")
        expect.expectedFulfillmentCount = 2
        let expectedValues = ["Hello", "Hi"]
        
        // when
        var values = [String]()
        sut.observe(on: self) { (value) in
            values.append(value)
            expect.fulfill()
        }
        self.sut.value = "Hello"
        self.sut.value = "Hi"
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(values, expectedValues)
    }
    
    func test_whenObserverOnDeallocated_thenShouldNotReceiveAnyValue() {
        // given
        let expect = expectation(description: "Wait for observe() to receive a value")
        expect.isInverted = true
        var object: NSObject? = NSObject()
        
        // when
        var gotMessage: String?
        sut.observe(on: object!) { (message) in
            gotMessage = message
        }
        object = nil
        sut.value = "Hello"
        
        // then
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertNil(gotMessage)
    }

}
