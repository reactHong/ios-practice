//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Hong Shik Kim on 2023/04/15.
//

import Foundation

struct FeedItem : Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}

