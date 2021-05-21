//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Combine
import Foundation

public protocol RequestBuilder {

    func accountRequest() -> URLRequest
    func annotationRequest() -> URLRequest
    func artistRequest(id: Int) -> URLRequest
    func referentRequest(id: Int) -> URLRequest
    func searchRequest(terms: String) -> URLRequest
    func songRequest(id: Int) -> URLRequest

}

/// Protocol for clients of the Genius.com API (https://api.genius.com). Note
/// that no functions relating to authenticating with the genius.com server are
/// included in this protocol; they can be found in the `GeniusClient`
/// implementation instead.
public protocol Genius: AnyObject {

    /// Get the currently-authenticated user's account information.
    ///
    /// - returns: A `Future` that yields a `GeniusAccount` if the
    ///            request is successful, or an error if it wasn't.
    func account() -> Future<GeniusAccount, Error>

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    ///
    /// - returns: A `Future` that yields a `GeniusAnnotation` if
    ///            the request was successful, or an error if it isn't.
    func annotation(id: Int) -> Future<GeniusAnnotation, Error>

    /// Get a specific artist.
    ///
    /// - parameter id: The artist's Genius ID. This can be obtained by
    ///                 searching for the artist, or from the corresponding
    ///                 field in a `GeniusSong`
    ///
    /// - returns: A `Future` that yields a `GeniusArtist` if the
    ///            request was successful, or an error if it isn't.
    func artist(id: Int) -> Future<GeniusArtist, Error>

    /// Get the annotated lyric segments of a specified song. **Genius.com does
    /// not have an API for getting *all* of a song's lyrics due to copyright
    /// restrictions.**
    ///
    /// - parameter id: The song's Genius ID.
    ///
    /// - returns: A `Future` that yields a `GeniusReferent` if the
    ///            request was successful, or an error if it isn't.
    func referents(forSongId id: Int) -> Future<[GeniusReferent], Error>

    /// Search for content on Genius.com. Search results are generally lists of
    /// songs that match, so that an artist search returns that artist's top
    /// *n* songs, an album search returns that album's songs, etc.
    ///
    /// - returns: A `Future` that yields a `GeniusSearch` if the
    ///            request was successful, or an error if it isn't.
    func search(terms: String) -> Future<GeniusSearch, Error>

    /// Get a specific song from the Genius database.
    ///
    /// - parameter id: The song's unique ID. This can be found in search
    ///             results or in corresponding fields from other Genius data
    ///             types.
    ///
    /// - returns: A `Future` that yields a `GeniusSong` if the
    ///            request was successful, or an error if it isn't.
    func song(id: Int) -> Future<GeniusSong, Error>

    /// Get all the songs by a specific artist. Unlike other Genius API calls,
    /// these results can be paged.
    ///
    /// - parameter byArtistId: The artist's Genius ID.
    /// - parameter sortOrder: Either by [GeniusSongSortOrder.popularity] or
    ///             [GeniusSongSortOrder.title].
    /// - parameter resultsPerPage: The number of songs to include in each
    ///             page of results.
    /// - parameter pageNumber: The index of the search results pages. These
    ///             start at 0.
    ///
    /// - returns: A `Future` that yields a `GeniusArtistSongs` if
    ///            the request was successful, or an error if it isn't.
    func songs(byArtistId artistId: Int,
               sortOrder: GeniusSongSortOrder,
               resultsPerPage: Int,
               pageNumber: Int) -> Future<[GeniusSong], Error>

}

/// The acceptable values for the `sortOrder` parameter of the
/// `Genius.songs(byArtistId:sortOrder:resultsPerPage:pageNumber)`
/// function.
public enum GeniusSongSortOrder: String, Codable {
    case popularity
    case title
}
