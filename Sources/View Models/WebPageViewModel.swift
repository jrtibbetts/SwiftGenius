//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class WebPageViewModel: GeniusElementModel<GeniusWebPage> {

    open func fetchWebPage(genius: GeniusClient, urlString: String) {
        loading = true

        Task {
            do {
                self.element = try await genius.webPage(urlString: urlString)
            } catch {
                self.error = error
            }

            loading = false
        }
    }

}
