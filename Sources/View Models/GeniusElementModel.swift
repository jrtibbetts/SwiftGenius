//  Copyright © 2021 Poikile Creations. All rights reserved.

import Combine
import SwiftUI

/// A view model for fetching a single ``Genius`` ``Responsable`` type.
open class GeniusElementModel<G: GeniusElement>: NSObject, ObservableObject {

    @Published public var element: G?
    @Published public var error: Error?
    @Published public var loading: Bool = false

}

/// A view model for fetching an array of a ``Genius` ``Responsable`` type.
open class GeniusElementArrayModel<G: GeniusElement>: NSObject, ObservableObject {

    @Published public var elements: [G]?
    @Published public var error: Error?
    @Published public var loading: Bool = false

}
