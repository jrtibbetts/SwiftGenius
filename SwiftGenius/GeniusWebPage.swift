//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

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

    public typealias Response = GeniusResponse<GeniusWebPage.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var webPage: GeniusWebPage

    }

}
