//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

class SearchResultsViewModel: GeniusElementArrayModel<GeniusSearch> {

    func fetchSearchResults(genius: GeniusClient, searchTerms: String) {
        super.fetch(genius.search(terms: searchTerms))
    }

}
