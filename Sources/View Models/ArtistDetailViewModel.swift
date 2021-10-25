//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class ArtistDetailViewModel: GeniusElementModel<GeniusArtist> {

    open func fetchArtist(id: Int, genius: GeniusClient) {
        loading = true

        Task {
            do {
                self.element = try await genius.artist(id: id)
            } catch {
                self.error = error
            }

            loading = false
        }

    }

}
