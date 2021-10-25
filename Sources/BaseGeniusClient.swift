//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public protocol RequestBuilder {

    func accountRequest() -> URLRequest?
    func annotationRequest(id: Int) -> URLRequest?
    func artistRequest(id: Int) -> URLRequest?
    func referentsRequest(songId: Int) -> URLRequest?
    func searchRequest(terms: String) -> URLRequest?
    func songRequest(id: Int) -> URLRequest?
    func webPageRequest(urlString: String) -> URLRequest?

}

public enum HTTPError: LocalizedError {

    case statusCode(Int)

}

public enum GeniusError: Error {

    case invalidRequest
    case unimplemented(functionName: String)

}

/// Protocol for clients of the Genius.com API (https://api.genius.com). Note
/// that no functions relating to authenticating with the genius.com server are
/// included in this protocol; they can be found in the `GeniusClient`
/// implementation instead.
public class BaseGeniusClient: NSObject, ObservableObject {

    public static var jsonDecoder = GeniusDecoder()

    internal var requestBuilder: RequestBuilder

    // MARK: - Initializer

    internal init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }

    /// Get the currently-authenticated user's account information.
    ///
    /// - returns: A `Future` that yields a `GeniusAccount` if the
    ///            request is successful, or an error if it wasn't.
    open func account() async throws -> GeniusAccount {
        return try await fetchElement(for: requestBuilder.accountRequest()) { (accountResponse) in
            return accountResponse.response!.user
        }
    }

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    ///
    /// - returns: A `Future` that yields a `GeniusAnnotation` if
    ///            the request was successful, or an error if it isn't.
    open func annotation(id: Int) async throws -> GeniusAnnotation {
        return try await fetchElement(for: requestBuilder.annotationRequest(id: id)) { (annotationResponse) in
            return annotationResponse.response!.annotation
        }
    }

    /// Get a specific artist.
    ///
    /// - parameter id: The artist's Genius ID. This can be obtained by
    ///                 searching for the artist, or from the corresponding
    ///                 field in a `GeniusSong`
    ///
    /// - returns: A `Future` that yields a `GeniusArtist` if the
    ///            request was successful, or an error if it isn't.
    open func artist(id: Int) async throws -> GeniusArtist {
        return try await fetchElement(for: requestBuilder.artistRequest(id: id)) { (artistResponse) in
            return artistResponse.response!.artist
        }
    }

    /// Get the annotated lyric segments of a specified song. **Genius.com does
    /// not have an API for getting *all* of a song's lyrics due to copyright
    /// restrictions.**
    ///
    /// - parameter id: The song's Genius ID.
    ///
    /// - returns: A `Future` that yields a `GeniusReferent` if the
    ///            request was successful, or an error if it isn't.
    open func referents(songId: Int) async throws -> [GeniusReferent] {
        return try await fetchElements(for: requestBuilder.referentsRequest(songId: songId)) { (referentsResponse) in
            return referentsResponse.response!.referents
        }
    }

    /// Search for content on Genius.com. Search results are generally lists of
    /// songs that match, so that an artist search returns that artist's top
    /// *n* songs, an album search returns that album's songs, etc.
    ///
    /// - returns: A `Future` that yields a `GeniusSearch` if the
    ///            request was successful, or an error if it isn't.
    open func search(terms: String) async throws -> [GeniusSearch] {
        return try await fetchElements(for: requestBuilder.searchRequest(terms: terms)) { (searchResponse) in
            return searchResponse.response!.hits
        }
    }

    /// Get a specific song from the Genius database.
    ///
    /// - parameter id: The song's unique ID. This can be found in search
    ///             results or in corresponding fields from other Genius data
    ///             types.
    ///
    /// - returns: A `Future` that yields a `GeniusSong` if the
    ///            request was successful, or an error if it isn't.
    open func song(id: Int) async throws -> GeniusSong {
        return try await fetchElement(for: requestBuilder.songRequest(id: id)) { (songResponse) in
            return songResponse.response!.song
        }
    }

    open func webPage(urlString: String) async throws -> GeniusWebPage {
        return try await fetchElement(for: requestBuilder.webPageRequest(urlString: urlString)) { (webPageResponse) in
            return webPageResponse.response!.webPage
        }
    }

    private func fetchElement<T: GeniusElement>(for request: URLRequest?,
                                                map: @escaping (T.Response) -> T) async throws -> T {
        guard let request = request else {
            throw GeniusError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw HTTPError.statusCode(httpResponse.statusCode)
        }

        let element = try Self.jsonDecoder.decode(T.Response.self, from: data)

        return map(element)
    }

    private func fetchElements<T: GeniusElement>(for request: URLRequest?,
                                                 map: @escaping (T.Response) -> [T]) async throws -> [T] {
        guard let request = request else {
            throw GeniusError.invalidRequest
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            throw HTTPError.statusCode(httpResponse.statusCode)
        }

        let element = try Self.jsonDecoder.decode(T.Response.self, from: data)

        return map(element)
    }

}

/// The acceptable values for the `sortOrder` parameter of the
/// `Genius.songs(byArtistId:sortOrder:resultsPerPage:pageNumber)`
/// function.
public enum GeniusSongSortOrder: String, Codable {
    case popularity
    case title
}
