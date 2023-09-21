//
//  RemoteFeedLoader.swift
//  EssentialFeedEx1
//
//  Created by Hong Shik Kim on 2023/09/07.
//

import Foundation

public protocol HTTPClient {
    func get(from: URL)
}

public class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
