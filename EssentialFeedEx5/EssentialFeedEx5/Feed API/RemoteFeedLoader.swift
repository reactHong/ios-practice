//
//  RemoteFeedLoader.swift
//  EssentialFeedEx5
//
//  Created by Hong Shik Kim on 2023/11/02.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failed(Error)
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
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch (result) {
            case .success(let response, let data):
                completion(FeedItemsMapper.map(response, data))
            case .failed:
                completion(.failed(.connectivity))
            }
        }
    }
}


