//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedEx1Tests
//
//  Created by Hong Shik Kim on 2023/09/07.
//

import XCTest
import EssentialFeedEx1

/*
 RemoteFeedLoader의 역할: 원격으로부터 FeedItem을 load한다.
 - func load: 원격으로부터 가져와야하니 completion block을 인자로 받아야 함
 - URL로 request를 보내서 서버에 데이터를 요청해야하는데, request를 보내는 라이브러리가 다양하므로 HTTPClient와 같은 클래스를 통해 원격과 통신할 수 있도록 한다.
 - HTTPClient의 내용이 바뀌어도 RemoteFeedLoader는 수정이 없도록 처리해야한다.
 - HTTPClient에는 URL 정보가 있어야 한다.

*/

class HTTPClient {
    static let shared = HTTPClient()
    
    private init() {}
    
    var requestedURL: URL?
}

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://any-url.com")!
        
    }
}


final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestsDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }

}
