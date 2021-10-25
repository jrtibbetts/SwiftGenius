//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class AccountViewModel: GeniusElementModel<GeniusAccount> {

    open func fetchAccount(genius: GeniusClient) {
        loading = true

        Task {
            do {
                self.element = try await genius.account()
            } catch {
                self.error = error
            }

            loading = false
        }
    }

}
