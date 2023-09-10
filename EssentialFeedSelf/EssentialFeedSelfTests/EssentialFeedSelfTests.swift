//
//  EssentialFeedSelfTests.swift
//  EssentialFeedSelfTests
//
//  Created by Hong Shik Kim on 2023/08/19.
//

import XCTest
@testable import EssentialFeedSelf

final class EssentialFeedSelfTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the co ΩΩΩrrect results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testRequest() {
        let loader = RemoteFeedLoaderTemp()
        
        let exp = expectation(description: "Wait for load completion")
        
        loader.load { result in
            print("testRequest")
            print(result)
            switch (result) {
            case .success(let items):
                XCTAssertEqual(items.isEmpty, true)
            default:
                break
            }
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5.0)
    }

}
