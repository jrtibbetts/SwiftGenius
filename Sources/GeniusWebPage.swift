//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusWebPage: GeniusElement {

    public var annotationCount: Int
    public var domain: String
    // swiftlint:disable identifier_name
    public var id: Int
    // swiftlint:enable identifier_name
    public var normalizedUrl: URL
    public var shareUrl: URL
    public var title: String
    public var url: URL

    public typealias Response = GeniusResponse<GeniusWebPage.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var webPage: GeniusWebPage

    }

}
