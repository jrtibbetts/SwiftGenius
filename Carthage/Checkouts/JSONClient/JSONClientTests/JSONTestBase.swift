//  Copyright © 2017 nrith. All rights reserved.

@testable import JSONClient
import XCTest

public class JSONTestBase: XCTestCase {

    func jsonObject<T: Codable>(inLocalJsonFileNamed fileName: String,
                                inBundle bundle: Bundle = Bundle.main) -> T? {
        do {
            let jsonUrl = try JSONUtils.url(forFileNamed: fileName, ofType: "json", inBundle: bundle)

            return jsonObject(fromUrl: jsonUrl)
        } catch {
            XCTFail("\(error.localizedDescription)")
        }

        return nil
    }

    func jsonObject<T: Codable>(fromUrl jsonUrl: URL) -> T? {
        do {
            if let object: T? = try JSONUtils.jsonObject(atUrl: jsonUrl) {
                return object
            } else {
                XCTFail("Parsing the response from '\(jsonUrl) produced an invalid object.")
            }
        } catch {
            XCTFail("\(error.localizedDescription)")
        }

        return nil
    }

}

