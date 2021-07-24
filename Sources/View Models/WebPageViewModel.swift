//  Created by Jason R Tibbetts on 7/21/21.

import Foundation

open class WebPageViewModel: GeniusElementModel<GeniusWebPage> {

    open func fetchWebPage(genius: GeniusClient, urlString: String) {
        super.fetch(genius.webPage(urlString: urlString))
    }

}
