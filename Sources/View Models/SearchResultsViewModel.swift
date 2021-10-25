//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SearchResultsViewModel: GeniusElementArrayModel<GeniusSearch> {

    open func fetchSearchResults(genius: GeniusClient, searchTerms: String) {
        loading = true

        Task {
            do {
                self.elements = try await genius.search(terms: searchTerms)
            } catch {
                self.error = error
            }

            loading = false
        }
    }

}
