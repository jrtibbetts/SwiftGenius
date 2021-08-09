//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class WebPageViewModel: GeniusElementModel<GeniusWebPage> {

    open func fetchWebPage(genius: GeniusClient, urlString: String) {
        super.fetch(genius.webPage(urlString: urlString))
    }

}
