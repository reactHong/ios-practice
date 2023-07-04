//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/07/04.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
