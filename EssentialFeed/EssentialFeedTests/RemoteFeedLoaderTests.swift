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
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNone200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        [199, 201, 300, 400, 500].enumerated().forEach { index, statusCode in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: statusCode, at: index)
            })
        }
    }
    
    func test_load_deliversErroOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data.init("invalid JSON".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithJSONEmptyList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = Data.init("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        let (item1, itemJSON1) = makeDummyItem(
            id: UUID(),
            description: nil,
            location: nil,
            imageURL: "https://a-image-url.com")
        
        let (item2, itemJSON2) = makeDummyItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: "https://a-image-url.com")
        
        let itemsJSON = [
            "items": [itemJSON1, itemJSON2]
        ]
        
        expect(sut, toCompleteWith: .success([item1, item2]), when: {
            //Dictionary to Data
            let data = try! JSONSerialization.data(withJSONObject: itemsJSON)
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        
        return (sut: sut, client: client)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: ()->Void, file: StaticString = #file, line: UInt = #line) {
        
        var capturedResults: [RemoteFeedLoader.Result] = []
        sut.load() { capturedResults.append($0)}
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
    }
    
    private func makeDummyItem(id: UUID, description: String?, location: String?, imageURL: String) -> (FeedItem, [String:String]) {
        let item = FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: URL(string: imageURL)!)
        
        let itemJSON = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.imageURL.absoluteString
        ].compactMapValues { $0 }
        
        return (item, itemJSON)
    }
    
    private class HTTPClientSpy : HTTPClient {
        
        private var messages: [(url: URL, completion: (HTTPClientResult)->Void)] = []
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: messages[index].url,
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success(response, data))
        }
    }

}
