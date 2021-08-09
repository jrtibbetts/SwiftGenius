//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SongDetailViewModel: GeniusElementModel<GeniusSong> {

    open func fetchSong(genius: GeniusClient, songId: String) {
        super.fetch(genius.song(id: Int(songId)!))
    }

}
