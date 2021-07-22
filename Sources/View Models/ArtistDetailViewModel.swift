//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

open class ArtistDetailViewModel: GeniusElementModel<GeniusArtist> {

    open func fetchArtist(id: Int, genius: GeniusClient) {
        super.fetch(genius.artist(id: id))
    }

}
