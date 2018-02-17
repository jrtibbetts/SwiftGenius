//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import PromiseKit
import XCTest

class ClientTestBase: XCTestCase {

    var timeoutSeconds: TimeInterval = 5.0

    @discardableResult
    func assert<T>(validPromise promise: Promise<T>,
                   description: String = "valid \(type(of: T.self))") -> T? {
        let exp = expectation(description: description)
        var returnableObject: T?

        promise.then { (fetchedObject) -> Void in
            returnableObject = fetchedObject
            exp.fulfill()
        }.catch { (error) in
            XCTFail(error.localizedDescription)
        }

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableObject
    }

    @discardableResult
    func assert<T>(invalidPromise promise: Promise<T>,
                   description: String = "invalid \(type(of: T.self))") -> Error? {
        let exp = expectation(description: description)
        var returnableError: Error?

        promise.then { (fetchedObject) in
            XCTFail("Expected an error to be thrown.")
        }.catch { (error) -> Void in
            returnableError = error
            exp.fulfill()
        }

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableError
    }

}
