//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Combine
import Foundation

public protocol RequestBuilder {

    func accountRequest() -> URLRequest?
    func annotationRequest(id: Int) -> URLRequest?
    func artistRequest(id: Int) -> URLRequest?
    func referentsRequest(forSongId: Int) -> URLRequest?
    func searchRequest(terms: String) -> URLRequest?
    func songRequest(id: Int) -> URLRequest?

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

    public static var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }()

    internal var requestBuilder: RequestBuilder

    // MARK: - Initializer

    internal init(requestBuilder: RequestBuilder) {
        self.requestBuilder = requestBuilder
    }

    /// Get the currently-authenticated user's account information.
    ///
    /// - returns: A `Future` that yields a `GeniusAccount` if the
    ///            request is successful, or an error if it wasn't.
    open func account() -> AnyPublisher<GeniusAccount, Error> {
        return publisher(for: requestBuilder.accountRequest()) { (accountResponse) in
            return accountResponse.response!.user
        }
    }

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    ///
    /// - returns: A `Future` that yields a `GeniusAnnotation` if
    ///            the request was successful, or an error if it isn't.
    open func annotation(id: Int) -> AnyPublisher<GeniusAnnotation, Error> {
        return publisher(for: requestBuilder.annotationRequest(id: id)) { (annotationResponse) in
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
    open func artist(id: Int) -> AnyPublisher<GeniusArtist, Error> {
        return publisher(for: requestBuilder.artistRequest(id: id)) { (artistResponse) in
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
//    open func referents(forSongId id: Int) -> AnyPublisher<[GeniusReferent], Error> {
//        return publisher(for: requestBuilder.referentsRequest(id: id))
//    }

    /// Search for content on Genius.com. Search results are generally lists of
    /// songs that match, so that an artist search returns that artist's top
    /// *n* songs, an album search returns that album's songs, etc.
    ///
    /// - returns: A `Future` that yields a `GeniusSearch` if the
    ///            request was successful, or an error if it isn't.
    open func search(terms: String) -> AnyPublisher<[GeniusSearch], Error> {
        return publisher(for: requestBuilder.searchRequest(terms: terms)) { (searchResponse) in
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
    open func song(id: Int) -> AnyPublisher<GeniusSong, Error> {
        return publisher(for: requestBuilder.songRequest(id: id)) { (songResponse) in
            return songResponse.response!.song
        }
    }

    private func publisher<T: GeniusElement>(for request: URLRequest?,
                                           map: @escaping (T.Response) -> T) -> AnyPublisher<T, Error> {
        guard let request = request else {
            return Future<T, Error> { (future) in
                future(.failure(GeniusError.invalidRequest))
            }
            .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (output) in
                if let httpResponse = output.response as? HTTPURLResponse,
                          httpResponse.statusCode != 200 {
                    throw HTTPError.statusCode(httpResponse.statusCode)
                }

                return output.data
            }
            .decode(type: T.Response.self, decoder: Self.jsonDecoder)
            .map { map($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func publisher<T: GeniusElement>(for request: URLRequest?,
                                           map: @escaping (T.Response) -> [T]) -> AnyPublisher<[T], Error> {
        guard let request = request else {
            return Future<[T], Error> { (future) in
                future(.failure(GeniusError.invalidRequest))
            }
            .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (output) in
                if let httpResponse = output.response as? HTTPURLResponse,
                          httpResponse.statusCode != 200 {
                    throw HTTPError.statusCode(httpResponse.statusCode)
                }

                return output.data
            }
            .decode(type: T.Response.self, decoder: Self.jsonDecoder)
            .map { map($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

}

/// The acceptable values for the `sortOrder` parameter of the
/// `Genius.songs(byArtistId:sortOrder:resultsPerPage:pageNumber)`
/// function.
public enum GeniusSongSortOrder: String, Codable {
    case popularity
    case title
}
