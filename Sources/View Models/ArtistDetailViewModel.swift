//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class ArtistDetailViewModel: GeniusElementModel<GeniusArtist> {

    open func fetchArtist(id: Int, genius: GeniusClient) {
        loading = true

        Task {
            do {
                let newElement = try await genius.artist(id: id)

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
