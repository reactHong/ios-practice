//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedEx1Tests
//
//  Created by Hong Shik Kim on 2023/09/07.
//

import XCTest
import EssentialFeedEx1
//@testable import EssentialFeedEx1

/*
 RemoteFeedLoader의 역할: 원격으로부터 FeedItem을 load한다.
 - func load: 원격으로부터 가져와야하니 completion block을 인자로 받아야 함
 - URL로 request를 보내서 서버에 데이터를 요청해야하는데, request를 보내는 라이브러리가 다양하므로 HTTPClient와 같은 클래스를 통해 원격과 통신할 수 있도록 한다.
 - HTTPClient의 내용이 바뀌어도 RemoteFeedLoader는 수정이 없도록 처리해야한다.
 - HTTPClient에는 URL 정보가 있어야 한다.

*/
/*
 Goal: Use dependecy injection instead of Global shared variable
 Why: RemoteFeedLoader does not need to know about HTTPClient.shared
 */
/*
 Goal: URL을 RemoteFeedLoader에게 전달해줌으로써 전달한 URL과 request한 URL이 같은지 체크
 */
/*
 Goal: Separate production code from testing code
 */
/*
 Goal: Make testing failed to invoke client.get functions in the RemoteFeedLoader.load function
 */



final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (client, _) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://any-url.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestDataFromURLTwice() {
        let url = URL(string: "https://any-url.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (client, sut) = makeSUT()
        client.error = NSError(domain: "Test", code: 0)
        
        var capturedError: RemoteFeedLoader.Error?
        sut.load { error in capturedError = error }
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    
    // MARK: - Helpers
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (client: HTTPClientSpy, sut: RemoteFeedLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(client: client, url: url)
        
        return (client, sut)
    }
    
    
    private class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        var error: Error?
        
        func get(from url: URL, completion: (Error)->Void) {
            requestedURLs.append(url)
            
            if let error = error {
                completion(error)
            }
            
        }
    }
}
