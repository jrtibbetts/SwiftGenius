//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusReferent: Codable {

    public var annotatable: Annotatable
    public var annotations: [GeniusAnnotation]?
    public var annotatorId: Int
    public var annotatorLogin: String
    public var apiPath: String
    public var classification: String
    public var featured: Bool?
    public var fragment: String?
    public var id: Int
    public var isDescription: Bool
    public var path: String
//        public var range: Range
    public var songId: Int?
    public var type: String
    public var url: URL
    public var verifiedAnnotatorIds: [Int]?

    fileprivate enum CodingKeys: String, CodingKey {
        case annotatable
        case annotations
        case annotatorId = "annotator_id"
        case annotatorLogin = "annotator_login"
        case apiPath = "api_path"
        case classification
        case featured
        case fragment
        case id
        case isDescription = "is_description"
        case path
        case songId = "song_id"
        case type = "_type"
        case url
        case verifiedAnnotatorIds = "verified_annotator_ids"
    }

    public struct Annotatable: Codable {
        public var apiPath: String
        public var context: String
        public var id: Int
        public var imageUrl: URL
        public var linkTitle: String?
        public var title: String?
        public var type: String
        public var url: URL

        fileprivate enum CodingKeys: String, CodingKey {
            case apiPath = "api_path"
            case context
            case id
            case imageUrl = "image_url"
            case linkTitle = "link_title"
            case title
            case type
            case url
        }
    }

    public typealias Response = GeniusResponse<GeniusReferent.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var referents: [GeniusReferent]
    }

}
