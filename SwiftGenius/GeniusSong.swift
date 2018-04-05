//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

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
    public var headerThumbnailImageUrl: URL?
    public var headerImageUrl: URL?
    public var id: Int
    public var lyricsOwnerId: Int
    public var lyricsState: String?
    public var path: String
    public var pyongsCount: Int?
//    public var recordingLocation: Location?
    public var releaseDate: String?
    public var songArtImageThumbnailUrl: URL?
    public var songArtImageUrl: URL?
    public var songStoryEmbedUrl: URL?
    public var stats: Stats?
    public var title: String
    public var titleWithFeatured: String?
    public var url: URL?

    public struct FactTrack: Codable {

        public var provider: String
        public var externalUrl: String
        public var buttonText: String
        public var helpLinkText: String
        public var helpLinkUrl: String

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
        public var pageviews: Int?

    }

    public struct Album: Codable {

        public var apiPath: String
        public var artist: ArtistOverview?
        public var coverArtUrl: URL?
        public var fullTitle: String
        public var id: Int
        public var name: String
        public var url: URL?

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

    }

    public typealias Response = GeniusResponse<GeniusSong.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var song: GeniusSong

    }

}
