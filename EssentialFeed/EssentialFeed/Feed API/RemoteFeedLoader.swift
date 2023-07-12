//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/04/16.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Result : Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .success(response, data):
                let result = self.getResult(response: response, data: data)
                completion(result)
                break
            case .failure:
                completion(.failure(.connectivity))
                break
            }
        }
        //NOTE: Can fix by testing code if the code duplicated when merging
//        client.get(from: url) { error in
//            completion(.connectivity)
//        }
    }
    
    private func getResult(response: HTTPURLResponse, data: Data) -> Result {
        do {
            let items = try FeedItemsMapper.map(response, data)
            return .success(items)
        } catch {
            return .failure(.invalidData)
        }
    }
}






