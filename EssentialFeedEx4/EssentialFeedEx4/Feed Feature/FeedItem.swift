//
//  FeedItem.swift
//  EssentialFeedEx4
//
//  Created by Hong Shik Kim on 2023/10/24.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let url: URL
}
