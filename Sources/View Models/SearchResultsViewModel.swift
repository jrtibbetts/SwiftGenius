//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class SearchResultsViewModel: GeniusElementArrayModel<GeniusSearch> {

    open func fetchSearchResults(genius: GeniusClient, searchTerms: String) {
        super.fetch(genius.search(terms: searchTerms))
    }

}
