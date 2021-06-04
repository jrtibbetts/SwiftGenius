//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusReferent: GeniusElement {

    public var annotatable: Annotatable
    public var annotations: [GeniusAnnotation]?
    public var annotatorId: Int
    public var annotatorLogin: String
    public var apiPath: String
    public var classification: String
    public var featured: Bool?
    public var fragment: String?
    // swiftlint:disable identifier_name
    public var id: Int
    // swiftlint:enable identifier_name
    public var isDescription: Bool
    public var path: String
//    public var range: Range
    public var songId: Int?
    public var type: String
    public var url: URL
    public var verifiedAnnotatorIds: [Int]?

    private enum CodingKeys: String, CodingKey {
        case annotatable
        case annotations
        case annotatorId
        case annotatorLogin
        case apiPath
        case classification
        case featured
        case fragment
        // swiftlint:disable identifier_name
        case id
        // swiftlint:enable identifier_name
        case isDescription
        case path
//        case range
        case songId
        case type = "_type"
        case url
        case verifiedAnnotatorIds
    }

    public struct Annotatable: Codable {

        public var apiPath: String
        public var context: String
        // swiftlint:disable identifier_name
        public var id: Int
        // swiftlint:enable identifier_name
       public var imageUrl: URL
        public var linkTitle: String?
        public var title: String?
        public var type: String
        public var url: URL

    }

    public typealias Response = GeniusResponse<GeniusReferent.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var referents: [GeniusReferent]
        
    }

}
