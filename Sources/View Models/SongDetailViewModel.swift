//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SongDetailViewModel: GeniusElementModel<GeniusSong> {

    open func fetchSong(genius: GeniusClient, songId: String) {
        loading = true

        Task {
            do {
                self.element = try await genius.song(id: Int(songId)!)
            } catch {
                self.error = error
            }

            loading = false
        }
    }

}
