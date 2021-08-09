//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class ArtistDetailViewModel: GeniusElementModel<GeniusArtist> {

    open func fetchArtist(id: Int, genius: GeniusClient) {
        super.fetch(genius.artist(id: id))
    }

}
