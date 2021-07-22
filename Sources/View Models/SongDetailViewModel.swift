//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

class SongDetailViewModel: GeniusElementModel<GeniusSong> {

    func fetchSong(genius: GeniusClient, songId: String) {
        super.fetch(genius.song(id: Int(songId)!))
    }

}
