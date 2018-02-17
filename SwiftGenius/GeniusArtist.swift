//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusArtist: Codable {
    public var alternateNames: [String]?
    public var apiPath: String
    public var currentUserMetadata: GeniusCurrentUserMetadata?
    public var description: GeniusDescription?
//    public var descriptionAnnotation: DescriptionAnnotation?
    public var followersCount: Int?
    public var headerImageUrl: URL?
    public var imageUrl: URL?
    public var instagramName: String?
    public var iq: Int
    public var isMemeVerified: Bool = false
    public var isVerified: Bool = true
    public var name: String
    public var twitterName: String
    public var url: URL?
    public var user: GeniusAccount?

    fileprivate enum CodingKeys: String, CodingKey {
        case alternateNames = "alternate_names"
        case apiPath = "api_path"
        case currentUserMetadata = "current_user_metadata"
        case description
//        case descriptionAnnotation = "description_annotation"
        case followersCount = "followers_count"
        case headerImageUrl = "header_image_url"
        case imageUrl = "image_url"
        case instagramName = "instagram_name"
        case iq
        case isMemeVerified = "is_meme_verified"
        case isVerified = "is_verified"
        case name
        case twitterName = "twitter_name"
        case url
        case user
    }

    public typealias Response = GeniusResponse<GeniusArtist.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var artist: GeniusArtist
    }

}
