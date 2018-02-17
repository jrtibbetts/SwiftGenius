//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public struct GeniusAnnotation: Codable {

    public var apiPath: String
//    public var body: [Codable]
    public var commentCount: Int
    public var community: Bool?
//    public var customPreview: Codable?
    public var hasVoters: Bool
    public var id: Int
    public var pinned: Bool
    public var shareUrl: String
//    public var source: Codable?
    public var state: String?
    public var url: String
    public var verified: Bool
    public var votesTotal: Int
//    public var currentUserMetadata: CurrentUserMetadata?

    fileprivate enum CodingKeys: String, CodingKey {
        case apiPath = "api_path"
        case commentCount = "comment_count"
        case community
        case hasVoters = "has_voters"
        case id
        case pinned
        case shareUrl = "share_url"
        case state
        case url
        case verified
        case votesTotal = "votes_total"
    }

    public typealias Response = GeniusResponse<GeniusAnnotation.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var annotation: GeniusAnnotation
        public var referent: GeniusReferent
    }

}

