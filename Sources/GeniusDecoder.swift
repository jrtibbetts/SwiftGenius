//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation

open class GeniusDecoder: JSONDecoder {

    public override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
 
}
