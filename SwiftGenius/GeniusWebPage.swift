//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public struct GeniusWebPage: Codable {

    public var annotationCount: Int
    public var apiPath: String
    public var domain: String
    public var id: Int
    public var normalizedUrl: URL
    public var shareUrl: URL
    public var title: String
    public var url: URL

    fileprivate enum CodingKeys: String, CodingKey {
        case annotationCount = "annotation_count"
        case apiPath = "api_path"
        case domain
        case id
        case normalizedUrl = "normalized_url"
        case shareUrl = "share_url"
        case title
        case url
    }

    public typealias Response = GeniusResponse<GeniusWebPage.ResponseBlock>

    public struct ResponseBlock: Codable {

        fileprivate enum CodingKeys: String, CodingKey {
            case webPage = "web_page"
        }

        public var webPage: GeniusWebPage

    }

}
