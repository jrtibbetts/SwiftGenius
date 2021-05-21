//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public protocol Responsable: Codable {

    associatedtype Response: Codable

}

public struct GeniusArtist: Responsable {
    
    public var alternateNames: [String]?
    public var apiPath: String
    public var currentUserMetadata: GeniusCurrentUserMetadata?
    public var description: GeniusDescription?
//    public var descriptionAnnotation: DescriptionAnnotation?
    public var followersCount: Int?
    public var headerImageUrl: URL?
    public var imageUrl: URL?
    public var instagramName: String?
    // swiftlint:disable identifier_name
    public var iq: Int
    // swiftlint:enable identifier_name
    public var isMemeVerified: Bool = false
    public var isVerified: Bool = true
    public var name: String
    public var twitterName: String
    public var url: URL?
    public var user: GeniusAccount?

    public typealias Response = GeniusResponse<GeniusArtist.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var artist: GeniusArtist
        
    }

}
