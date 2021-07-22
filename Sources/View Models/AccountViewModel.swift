//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

open class AccountViewModel: GeniusElementModel<GeniusAccount> {

    open func fetchAccount(genius: GeniusClient) {
        super.fetch(genius.account())
    }

}
