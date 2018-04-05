//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation

public typealias IQAction = String
public typealias IQLevel = String

public struct GeniusContributor: Codable {

    public var resourceUrl: String
    public var username: String
    
}

public struct GeniusCurrentUserMetadata: Codable {

    public var permissions: [String]?
    public var excludedPermissions: [String]?
    public var interactions: [String : Bool?]
    public var iqByAction: [IQAction : [IQLevel : LevelModifiers]]?

    public struct LevelModifiers: Codable {
        public var applicable: Bool
        public var base: Float
        public var multiplier: Int
    }
    
}

public struct GeniusDescription: Codable {
    public var plain: String?
    public var html: String?
//    public var dom: DomNode?
}

//public struct DomNode: Codable {
//    public var tag: String
//    public var children: [AnyObject]?
//}

public struct GeniusAvatar: Codable {

    public var medium: Icon
    public var small: Icon
    public var thumb: Icon
    public var tiny: Icon

    public struct Icon: Codable {
        public var url: URL
        public var boundingBox: Rectangle
        
        public struct Rectangle: Codable {
            public var width: Int
            public var height: Int
        }
    }
    
}
