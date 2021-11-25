//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class ReferentsViewModel: GeniusElementArrayModel<GeniusReferent> {

    open func fetchReferents(genius: GeniusClient, song: GeniusSong) {
        loading = true

        Task {
            do {
                let newElements = try await genius.referents(songId: song.id)

                DispatchQueue.main.async {
                    self.elements = newElements
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
