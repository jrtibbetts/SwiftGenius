//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class AccountViewModel: GeniusElementModel<GeniusAccount> {

    open func fetchAccount(genius: GeniusClient) {
        super.fetch(genius.account())
    }

}
