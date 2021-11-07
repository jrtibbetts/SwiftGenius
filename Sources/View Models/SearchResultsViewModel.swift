//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SearchResultsViewModel: GeniusElementArrayModel<GeniusSearch> {

    open func fetchSearchResults(genius: GeniusClient, searchTerms: String) {
        loading = true

        Task {
            do {
                let newElements = try await genius.search(terms: searchTerms)

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
