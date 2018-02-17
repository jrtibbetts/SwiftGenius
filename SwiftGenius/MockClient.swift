//  Copyright © 2018 nrith. All rights reserved.

import Foundation
import PromiseKit

/// Base class for mock client implementations of third-party services.
open class MockClient: NSObject {

    /// If `true`, each API call will pass a non-`nil` `Error` object to the
    /// completion block instead of a valid data object.
    public var errorMode: Bool = false

    /// The bundle that contains this implementation and the local JSON data
    /// files that is parses to return data.
    public private(set) var bundle: Bundle

    fileprivate let errorDomain: String

    public init(bundle: Bundle = Bundle.main) {
        self.errorMode = false
        self.errorDomain = "Error domains aren't used in non-error mode!"
        self.bundle = bundle
    }

    public init(errorDomain: String,
                bundle: Bundle = Bundle.main) {
        self.errorMode = true
        self.errorDomain = errorDomain
        self.bundle = bundle
    }

    // MARK: - Utilities

    public func apply<T: Codable>(toJsonObjectIn fileName: String,
                                  error: Error? = nil) -> Promise<T> {
        return Promise<T> { (fulfill, reject) in
            if errorMode {
                if let error = error {
                    reject(error)
                } else {
                    let error = NSError(domain: errorDomain, code: 0, userInfo: nil)
                    reject(error)
                }
            } else {
                do {
                    let obj: T = try JSONUtils.jsonObject(forFileNamed: fileName, inBundle: bundle)
                    fulfill(obj)
                } catch {
                    reject(error)
                }
            }
        }
    }

}
