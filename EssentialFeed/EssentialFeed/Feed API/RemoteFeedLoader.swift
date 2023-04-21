//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/04/16.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
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
        client.get(from: url) { error, response in
            
            if let _ = error {
                completion(.connectivity)
            }
            if let response = response {
                if response.statusCode != 200 {
                    completion(.invalidData)
                }
            }
        }
        //NOTE: Can fix by testing code if the code duplicated when merging
//        client.get(from: url) { error in
//            completion(.connectivity)
//        }
    }
}

