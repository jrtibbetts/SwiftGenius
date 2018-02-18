//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

public class JSONTestBase: XCTestCase {

    func jsonObject<T: Codable>(inLocalJsonFileNamed fileName: String,
                                inBundle bundle: Bundle = Bundle.main) throws -> T {
        let jsonUrl = try JSONUtils.url(forFileNamed: fileName, ofType: "json", inBundle: bundle)

        return try jsonObject(fromUrl: jsonUrl)
    }

    func jsonObject<T: Codable>(fromUrl jsonUrl: URL) throws -> T {
        return try JSONUtils.jsonObject(atUrl: jsonUrl)
    }

}

