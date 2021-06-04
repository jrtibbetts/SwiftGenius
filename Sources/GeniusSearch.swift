//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusSearch: GeniusElement {

    public var highlights: [String]
    public var index: String
    public var type: String
    public var result: GeniusSong

    public typealias Response = GeniusResponse<GeniusSearch.ResponseBlock>

    public struct ResponseBlock: Codable {
        
        public var hits: [GeniusSearch]

    }

}
