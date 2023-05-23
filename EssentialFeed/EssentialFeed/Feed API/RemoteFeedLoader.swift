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
        client.get(from: url) { result in
            
            switch result {
            case let .success(response, data):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    let feedItems = root.items.map { $0.item }
                    completion(.success(feedItems))
                } else {
                    completion(.failure(.invalidData))
                }
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
}

private struct Root: Decodable {
    let items: [Item]
}

private struct Item : Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
    
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
    
}

