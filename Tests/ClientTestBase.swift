//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import Combine
import XCTest

class ClientTestBase: XCTestCase {

    var timeoutSeconds: TimeInterval = 5.0

    @discardableResult
    func assert<T>(validPublisher publisher: AnyPublisher<T, Error>,
                   description: String = "valid \(type(of: T.self))",
                   file: StaticString = #file,
                   line: UInt = #line) -> T? {
        let exp = expectation(description: description)
        var returnableObject: T?

        let publisher = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                XCTFail(error.localizedDescription, file: file, line: line)
            default:
                return
            }
        }, receiveValue: { (value) in
            returnableObject = value
            exp.fulfill()
        })

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableObject 
    }

    @discardableResult
    func assert<T>(failingPublisher publisher: AnyPublisher<T, Error>,
                   description: String = "invalid \(type(of: T.self))",
                   file: StaticString = #file,
                   line: UInt = #line) -> Error? {
        let exp = expectation(description: description)
        var returnableError: Error?

        _ = publisher.sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                returnableError = error
                exp.fulfill()
            default:
                XCTFail("Expected an error to be thrown.", file: file, line: line)
            }
        }, receiveValue: { _ in
            XCTFail("Expected an error to be thrown.", file: file, line: line)
        })

        wait(for: [exp], timeout: timeoutSeconds)

        return returnableError
    }

}
