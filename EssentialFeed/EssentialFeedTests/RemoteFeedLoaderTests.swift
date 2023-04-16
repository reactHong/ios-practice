//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Hong Shik Kim on 2023/04/16.
//

import XCTest
import EssentialFeed
//NOTE: @testable is possible
//@testable import EssentialFeed

//NOTE: Moved to the production code
//class RemoteFeedLoader {
//    let url: URLs
//    let client: HTTPClient
//    
//    init(url: URL, client: HTTPClient) {
//        self.url = url
//        self.client = client
//    }
//    
//    func load() {
//        client.get(from: url)
//    }
//}
//
//protocol HTTPClient {
//    func get(from url: URL)
//}


class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        //XCTAssertNil(client.requestedURL)
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }
    
    private class HTTPClientSpy : HTTPClient {
        var requestedURLs: [URL] = []
        
        func get(from url: URL) {
            requestedURLs.append(url)
        }
    }

}
