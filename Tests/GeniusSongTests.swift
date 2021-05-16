//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusSongTests: GeniusTestBase {

    public static func assert(_ song: GeniusSong?) {
        guard song != nil else {
            XCTFail("The response is supposed to contain a song.")
            return
        }
    }

}
