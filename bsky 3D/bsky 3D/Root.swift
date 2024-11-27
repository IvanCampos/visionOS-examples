//
//  Root.swift
//  Jetstream
//
//  Created by IVAN CAMPOS on 11/24/24.
//

import Foundation

// Top-level JSON structure
struct Root: Codable {
    let did: String
    let timeUs: Int
    let kind: String
    let commit: Commit?

    enum CodingKeys: String, CodingKey {
        case did
        case timeUs = "time_us"
        case kind
        case commit
    }
}

// Commit structure
struct Commit: Codable {
    let rev: String?
    let operation: String?
    let collection: String?
    let rkey: String?
    let record: Record?
    let cid: String?
}

// Record structure
struct Record: Codable {
    let type: String?
    let createdAt: String?
    let embed: Embed?
    let langs: [String]?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case createdAt
        case embed
        case langs
        case text
    }
}

// Embed structure
struct Embed: Codable {
    let type: String?
    let media: Media?
    let record: EmbedRecord?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case media
        case record
    }
}

// Media structure
struct Media: Codable {
    let type: String?
    let external: External?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case external
    }
}

// External structure
struct External: Codable {
    let description: String?
    let thumb: Thumb?
    let title: String?
    let uri: String?
}

// Thumb structure
struct Thumb: Codable {
    let type: String?
    let ref: Ref?
    let mimeType: String?
    let size: Int?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case ref
        case mimeType
        case size
    }
}

// Ref structure
struct Ref: Codable {
    let link: String?

    enum CodingKeys: String, CodingKey {
        case link = "$link"
    }
}

// EmbedRecord structure
struct EmbedRecord: Codable {
    let type: String?
    let record: RecordDetails?

    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record
    }
}

// RecordDetails structure
struct RecordDetails: Codable {
    let cid: String?
    let uri: String?
}
