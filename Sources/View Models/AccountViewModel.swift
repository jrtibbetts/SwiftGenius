//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

class AccountViewModel: GeniusElementModel<GeniusAccount> {

    func fetchAccount(genius: GeniusClient) {
        super.fetch(genius.account())
    }

}
