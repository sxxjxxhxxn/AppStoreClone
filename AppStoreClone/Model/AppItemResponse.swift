//
//  AppItemResponse.swift
//  AppStoreClone
//
//  Created by Paul.S on 2020/08/10.
//  Copyright © 2020 Paul.S. All rights reserved.
//

import Foundation

public struct AppItem: Decodable {

    public let screenshotUrls: [String]
    public let artworkUrl100: String
    public let artworkUrl512: String
    public let artistViewUrl: String?
    public let sellerUrl: String?
    public let averageUserRating: Double
    public let trackContentRating: String
    public let trackName: String
    public let formattedPrice: String?
    public let currentVersionReleaseDate: String
    public let version: String
    public let artistName: String
    public let genres: [String]
    public let price: Float?
    public let description: String
    public let userRatingCount: Double
}

public struct AppItemResponse: Decodable {
    
    public let resultCount: Int
    public let results: [AppItem]
    
    public init() {
        self.resultCount = 0
        self.results = []
    }
}
