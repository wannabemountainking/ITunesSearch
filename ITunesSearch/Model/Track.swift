//
//  Track.swift
//  ITunesSearch
//
//  Created by YoonieMac on 3/19/26.
//

import Foundation


struct Tracks: Codable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Identifiable, Codable {
    let id = UUID()
    var trackName: String?
    var artistName: String?
    var collectionName: String?
    var primaryGenreName: String?
    var trackInfo: [(label: String, value: String?)] {
        [
            (label: "artist", value: artistName),
            (label: "collection", value: collectionName),
            (label: "genre", value: primaryGenreName)
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case trackName, artistName, collectionName, primaryGenreName
    }
    
}
