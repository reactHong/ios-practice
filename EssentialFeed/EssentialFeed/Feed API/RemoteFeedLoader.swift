//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/04/16.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { result in
            
            switch result {
            case .success:
                if case let .success(response, data) = result {
                    if response.statusCode != 200 {
                        completion(.invalidData)
                    } else {
                        if let _ = try? JSONDecoder().decode(FeedItem.self, from: data) {
                            
                        }
                        else {
                            completion(.invalidData)
                        }
                    }
                }
                break
            case .failure:
                completion(.connectivity)
                break
            }
        }
        //NOTE: Can fix by testing code if the code duplicated when merging
//        client.get(from: url) { error in
//            completion(.connectivity)
//        }
    }
}

