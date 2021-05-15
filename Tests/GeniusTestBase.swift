//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusTestBase: JSONTestBase {

    func geniusObject<T: Codable>(inLocalJsonFileNamed fileName: String) throws -> T {
        let bundle = SwiftGenius.resourceBundle

        return try jsonObject(inLocalJsonFileNamed: fileName, inBundle: bundle)
    }

}
