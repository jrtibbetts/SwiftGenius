//  Copyright © 2021 Poikile Creations. All rights reserved.

import Combine
import Foundation

public protocol Genius: ObservableObject {

    var isAuthenticated: Bool { get }

    func account() async throws -> GeniusAccount

    func annotation(id: Int) async throws -> GeniusAnnotation

    func artist(id: Int) async throws -> GeniusArtist

    func authorize() -> AnyPublisher<Bool, Error>

    func logOut()

    func referents(songId: Int) async throws -> [GeniusReferent]

    func search(terms: String) async throws -> [GeniusSearch]

    func song(id: Int) async throws -> GeniusSong

    func webPage(urlString: String) async throws -> GeniusWebPage

}

