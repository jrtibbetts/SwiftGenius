//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusTestBase: JSONTestBase {

    func geniusObject<T: Codable>(inLocalJsonFileNamed fileName: String) -> T? {
        let bundle = Bundle(for: MockGenius.self)

        return jsonObject(inLocalJsonFileNamed: fileName, inBundle: bundle)
    }

}
