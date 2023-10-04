//
//  RemoteFeedLoader.swift
//  EssentialFeedEx1
//
//  Created by Hong Shik Kim on 2023/09/07.
//

import Foundation

public protocol HTTPClient {
    func get(from: URL, completion: @escaping (Error)->Void)
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error {
        case connectivity
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error)->Void = { _ in }) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}
