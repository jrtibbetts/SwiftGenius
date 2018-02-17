//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public struct GeniusSearch: Codable {

    public var highlights: [String]
    public var index: String
    public var type: String
    public var result: GeniusSong

    public typealias Response = GeniusResponse<GeniusSearch.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var hits: [GeniusSearch]
    }

}

