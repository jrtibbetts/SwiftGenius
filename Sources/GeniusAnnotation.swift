//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusAnnotation: GeniusElement {

    public var apiPath: String
//    public var body: [Codable]
    public var commentCount: Int
    public var community: Bool?
//    public var customPreview: Codable?
    public var hasVoters: Bool
    // swiftlint:disable identifier_name
    public var id: Int
    // swiftlint:enable identifier_name
    public var pinned: Bool
    public var shareUrl: String
//    public var source: Codable?
    public var state: String?
    public var url: String
    public var verified: Bool
    public var votesTotal: Int
//    public var currentUserMetadata: CurrentUserMetadata?

    public typealias Response = GeniusResponse<GeniusAnnotation.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var annotation: GeniusAnnotation
        public var referent: GeniusReferent
    }

}
