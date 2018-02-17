//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public struct GeniusSong: Codable {

    public var annotationCount: Int
    public var album: Album?
    public var apiPath: String
    public var currentUserMetadata: GeniusCurrentUserMetadata?
//    public var descriptionAnnotation: GeniusDescription
    public var embedContent: String?
    public var factTrack: FactTrack?
    public var featuredVideo: Bool?
    public var fullTitle: String
    public var headerThumbnailUrl: URL?
    public var headerImageUrl: URL?
    public var id: Int
    public var lyricsOwnerId: Int
    public var lyricsState: String?
    public var path: String
    public var pyongsCount: Int?
//    public var recordingLocation: Location?
    public var releaseDate: String?
    public var songArtThumbnailUrl: URL?
    public var songArtUrl: URL?
    public var songStoryEmbedUrl: URL?
    public var stats: Stats?
    public var title: String
    public var titleWithFeatured: String?
    public var url: URL?

    fileprivate enum CodingKeys: String, CodingKey {
        case annotationCount = "annotation_count"
        case album
        case apiPath = "api_path"
        case currentUserMetadata = "current_user_metadata"
        //        case descriptionAnnotation = "description_annotation"
        case embedContent = "embed_content"
        case factTrack = "fact_track"
        case featuredVideo = "featured_video"
        case fullTitle = "full_title"
        case headerThumbnailUrl = "header_thumbnail_image_url"
        case headerImageUrl = "header_image_url"
        case id
        case lyricsOwnerId = "lyrics_owner_id"
        case lyricsState = "lyrics_state"
        case path
        case pyongsCount = "pyongs_count"
        //        case recordingLocation = "recording_location"
        case releaseDate = "release_date"
        case songArtThumbnailUrl = "song_art_image_thumbnail_url"
        case songArtUrl = "song_art_image_url"
        case songStoryEmbedUrl = "song_story_embed_url"
        case stats
        case title
        case titleWithFeatured = "title_with_featured"
        case url
    }

    public struct FactTrack: Codable {

        public var provider: String
        public var externalUrl: String
        public var buttonText: String
        public var helpLinkText: String
        public var helpLinkUrl: String

        fileprivate enum CodingKeys: String, CodingKey {
            case provider
            case externalUrl = "external_url"
            case buttonText = "button_text"
            case helpLinkText = "help_link_text"
            case helpLinkUrl = "help_link_url"
        }
    }

    public struct Stats: Codable {

        public var acceptedAnnotations: Int?
        public var contributors: Int?
        public var hot: Bool? = false
        public var iqEarners: Int?
        public var transcribers: Int?
        public var unreviewedAnnotations: Int?
        public var verifiedAnnotations: Int?
        public var concurrents: Int?
        public var pageViews: Int?

        fileprivate enum CodingKeys: String, CodingKey {
            case acceptedAnnotations = "accepted_annotations"
            case contributors
            case hot
            case iqEarners = "iq_earners"
            case transcribers
            case unreviewedAnnotations = "unreviewed_annotations"
            case verifiedAnnotations = "verified_annotations"
            case concurrents
            case pageViews = "pageviews"
        }
    }

    public struct Album: Codable {

        public var apiPath: String
        public var artist: ArtistOverview?
        public var coverArtUrl: URL?
        public var fullTitle: String
        public var id: Int
        public var name: String
        public var url: URL?

        fileprivate enum CodingKeys: String, CodingKey {
            case apiPath = "api_path"
            case artist
            case coverArtUrl = "cover_art_url"
            case fullTitle = "full_title"
            case id
            case name
            case url
        }
    }

    public struct ArtistOverview: Codable {

        public var apiPath: String
        public var headerImageUrl: URL?
        public var id: Int
        public var imageUrl: URL?
        public var isMemeVerified: Bool
        public var isVerified: Bool
        public var name: String
        public var url: URL
        public var iq: Int

        fileprivate enum CodingKeys: String, CodingKey {
            case apiPath = "api_path"
            case headerImageUrl = "header_image_url"
            case id
            case imageUrl = "image_url"
            case isMemeVerified = "is_meme_verified"
            case isVerified = "is_verified"
            case name
            case url
            case iq
        }
    }

    public typealias Response = GeniusResponse<GeniusSong.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var song: GeniusSong
    }

}
