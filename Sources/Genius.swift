//  Created by Jason R Tibbetts on 5/25/21.

import Combine
import Foundation

public protocol Genius: ObservableObject {

    var isAuthenticated: Bool { get }

    func account() -> AnyPublisher<GeniusAccount, Error>

    func annotation(id: Int) -> AnyPublisher<GeniusAnnotation, Error>

    func artist(id: Int) -> AnyPublisher<GeniusArtist, Error>

    func authorize()

    func logOut()

    func referents(songId: Int) -> AnyPublisher<[GeniusReferent], Error>

    func search(terms: String) -> AnyPublisher<[GeniusSearch], Error>

    func song(id: Int) -> AnyPublisher<GeniusSong, Error>

    func webPage(urlString: String) -> AnyPublisher<GeniusWebPage, Error>

}

