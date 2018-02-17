//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public struct GeniusAccount: Codable {

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
    public var humanReadableRole: String?
    public var id: Int
    public var identities: [Identity]?
    public var iq: Int
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

    fileprivate enum CodingKeys: String, CodingKey {
        case apiPath                      = "api_path"
        case availableIdentityProviders   = "available_identity_providers"
        case avatar
        case currentUserMetadata          = "current_user_metadata"
        case customHeaderImageUrl         = "custom_header_image_url"
        case email
        case followedUsersCount           = "followed_users_count"
        case followersCount               = "followed_users"
        case headerImageUrl               = "header_image_url"
        case humanReadableRole            = "human_readable_role_for_display"
        case id
        case identities
        case iq
        case iqForDisplay                 = "iq_for_display"
        case login
        case name
        case photoUrl                     = "photo_url"
        case preferences
        case roleForDisplay               = "role_for_display"
        case rolesForDisplay              = "roles_for_display"
        case stats
        case unreadGroupsInboxCount       = "unread_groups_inbox_count"
        case unreadMainActivityInboxCount = "unread_main_activity_inbox_count"
        case unreadMessagesCount          = "unread_messages_count"
        case unreadNewsfeedInboxCount     = "unread_newsfeed_inbox_count"
        case url
    }

    public struct Identity: Codable {
        public var id: Int
        public var name: String?
        public var provider: String
        public var customProperties: [String : String]?

        fileprivate enum CodingKeys: String, CodingKey {
            case customProperties = "custom_properties"
            case id
            case name
            case provider
        }
    }

    public typealias Response = GeniusResponse<GeniusAccount.ResponseBlock>

    public struct ResponseBlock: Codable {
        public var user: GeniusAccount
    }

    public struct Role: Codable {

    }

    public struct Stats: Codable {
        public var allActivitiesCount: Int
        public var annotationsCount: Int
        public var answersCount: Int
        public var commentsCount: Int
        public var forumPostsCount: Int
        public var pyongsCount: Int
        public var questionsCount: Int
        public var transcriptionsCount: Int

        fileprivate enum CodingKeys: String, CodingKey {
            case allActivitiesCount  = "all_activities_count"
            case annotationsCount    = "annotations_count"
            case answersCount        = "answers_count"
            case commentsCount       = "comments_count"
            case forumPostsCount     = "forum_posts_count"
            case pyongsCount         = "pyongs_count"
            case questionsCount      = "questions_count"
            case transcriptionsCount = "transcriptions_count"
        }
    }

}
