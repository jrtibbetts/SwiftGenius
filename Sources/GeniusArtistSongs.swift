//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusArtistSongs: GeniusElement {

    public typealias Response = GeniusResponse<GeniusArtistSongs.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var songs: [GeniusSong]?

    }
    
}
