//
//  HTTPClient.swift
//  EssentialFeedEx5
//
//  Created by Hong Shik Kim on 2023/11/14.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse, Data)
    case failed(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult)->Void)
}
