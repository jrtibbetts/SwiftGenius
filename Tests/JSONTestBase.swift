//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Stylobate
import XCTest

public class JSONTestBase: XCTestCase {

    func jsonObject<T: Codable>(inLocalJsonFileNamed fileName: String,
                                inBundle bundle: Bundle = Bundle.main) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let jsonUrl = try JSONUtils.url(forFileNamed: fileName, ofType: "json", inBundle: bundle)

        return try JSONUtils.jsonObject(atUrl: jsonUrl, decoder: decoder)
    }

}
