//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class WebPageViewModel: GeniusElementModel<GeniusWebPage> {

    open func fetchWebPage(genius: GeniusClient, urlString: String) {
        loading = true

        Task {
            do {
                let newElement = try await genius.webPage(urlString: urlString)

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
