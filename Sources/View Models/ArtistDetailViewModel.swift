//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

class ArtistDetailViewModel: GeniusElementModel<GeniusArtist> {

    public func fetchArtist(id: Int, genius: GeniusClient) {
        super.fetch(genius.artist(id: id))
    }

}
