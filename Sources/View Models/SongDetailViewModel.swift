//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SongDetailViewModel: GeniusElementModel<GeniusSong> {

    open func fetchSong(genius: GeniusClient, songId: String) {
        loading = true

        Task {
            do {
                let newElement = try await genius.song(id: Int(songId)!)

                DispatchQueue.main.async {
                    self.element = newElement
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                }
            }

            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }

}
