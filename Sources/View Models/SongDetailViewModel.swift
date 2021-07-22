//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

open class SongDetailViewModel: GeniusElementModel<GeniusSong> {

    open func fetchSong(genius: GeniusClient, songId: String) {
        super.fetch(genius.song(id: Int(songId)!))
    }

}
