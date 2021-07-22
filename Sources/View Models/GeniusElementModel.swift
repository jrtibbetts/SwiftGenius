//  Created by Jason R Tibbetts on 6/3/21.

import Combine
import SwiftUI

/// A view model for fetching a single ``Genius`` ``Responsable`` type.
open class GeniusElementModel<G: GeniusElement>: NSObject, ObservableObject {

    @Published public var element: G?
    @Published public var error: Error?
    @Published public var loading: Bool = false

    var requestCancellable: AnyCancellable?

    public func fetch(_ publisher: AnyPublisher<G, Error>) {
        loading = true

        requestCancellable = publisher
            .sink(receiveCompletion: { (completion) in
                self.loading = false
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { (element) in
                self.element = element
            })
    }

}

/// A view model for fetching an array of a ``Genius` ``Responsable`` type.
open class GeniusElementArrayModel<G: GeniusElement>: NSObject, ObservableObject {

    @Published public var elements: [G]?
    @Published public var error: Error?
    @Published public var loading: Bool = false

    var requestCancellable: AnyCancellable?

    public func fetch(_ publisher: AnyPublisher<[G], Error>) {
        loading = true

        requestCancellable = publisher
            .sink(receiveCompletion: { (completion) in
                self.loading = false
                switch completion {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { (elements) in
                self.elements = elements
            })
    }

}
