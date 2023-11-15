//
//  RemoteFeedLoader.swift
//  EssentialFeedEx4
//
//  Created by Hong Shik Kim on 2023/10/29.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult)->Void)
}

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Result)->Void) {
        //client.get(from: url)
        client.get(from: url) { result in
            switch (result) {
            case .success(_, let data):
                //data를 JSON으로 잘 변환되는지 체크
                if let _ = try? JSONSerialization.jsonObject(with: data) {
                    completion(.success([]))
                } else {
                    completion(.failure(.invalidData))
                }
                break
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
