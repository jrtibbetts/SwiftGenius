//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Combine
import UIKit

public class MockGenius: BaseGeniusClient, Genius {

    @Published public var isAuthenticated: Bool = false

    let errorMode: Bool
    let errorModeError = NSError(domain: "MockGenius", code: 9, userInfo: nil)

    public init(useErrorMode errorMode: Bool = false) {
        self.errorMode = errorMode

        super.init(requestBuilder: MockRequestBuilder(errorMode: errorMode))
    }

    public func authorize() async throws -> String {
        isAuthenticated = true

        return "some token"
    }

    public func logOut() {
        isAuthenticated = false
    }

    struct MockRequestBuilder: RequestBuilder {

        let errorMode: Bool

        func buildRequest(path: String) -> URLRequest? {
            if errorMode {
                return nil
            } else if let url = SwiftGenius.resourceBundle.url(forResource: path, withExtension: "json") {
                return URLRequest(url: url)
            } else {
                return nil
            }
        }

        func accountRequest() -> URLRequest? {
            return buildRequest(path: "get-account-200")
        }

        func annotationRequest(id: Int) -> URLRequest? {
            return buildRequest(path: "get-annotations-200")
        }

        func artistRequest(id: Int) -> URLRequest? {
            return buildRequest(path: "get-artists-200")
        }

        func referentsRequest(songId: Int) -> URLRequest? {
            return buildRequest(path: "get-referents-200")
        }

        func searchRequest(terms: String) -> URLRequest? {
            return buildRequest(path: "get-search-200")
        }

        func songRequest(id: Int) -> URLRequest? {
            return buildRequest(path: "get-songs-200")
        }

        func webPageRequest(urlString: String) -> URLRequest? {
            return buildRequest(path: "get-webpage-200")
        }

    }

}
