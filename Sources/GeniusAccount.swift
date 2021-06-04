//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusAccount: GeniusElement {

    public var apiPath: URL?
    //    public var artist: ?
    public var availableIdentityProviders: [String]?
    public var avatar: GeniusAvatar?
    public var currentUserMetadata: GeniusCurrentUserMetadata?
    public var customHeaderImageUrl: URL?
    public var email: String?
    public var followedUsersCount: Int?
    public var followersCount: Int?
    public var headerImageUrl: URL?
    public var humanReadableRoleForDisplay: String?
    // swiftlint:disable identifier_name
    public var id: Int
    // swiftlint:enable identifier_name
    public var identities: [Identity]?
    // swiftlint:disable identifier_name
    public var iq: Int
    // swiftlint:enable identifier_name
    public var iqForDisplay: String?
    public var login: String
    public var name: String
    public var photoUrl: URL?
    public var preferences: [String : Bool]?
    public var roleForDisplay: Role?
    public var rolesForDisplay: [Role]?
    public var stats: Stats?
    public var unreadGroupsInboxCount: Int?
    public var unreadMainActivityInboxCount: Int?
    public var unreadMessagesCount: Int?
    public var unreadNewsfeedInboxCount: Int?
    public var url: URL?

    public struct Identity: Codable {

        // swiftlint:disable identifier_name
        public var id: Int
        // swiftlint:enable identifier_name
        public var name: String?
        public var provider: String
        public var customProperties: [String : String]?

    }

    public typealias Response = GeniusResponse<GeniusAccount.ResponseBlock>

    public struct ResponseBlock: Codable {

        public var user: GeniusAccount

    }

    public struct Role: Codable {

    }

    public struct Stats: Codable {
        
        public var annotationsCount: Int
        public var answersCount: Int
        public var commentsCount: Int
        public var forumPostsCount: Int
        public var pyongsCount: Int
        public var questionsCount: Int
        public var transcriptionsCount: Int

    }

}
