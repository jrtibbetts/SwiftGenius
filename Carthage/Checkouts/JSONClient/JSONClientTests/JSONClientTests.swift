//  Copyright © 2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import PromiseKit
import XCTest

class JSONClientTests: XCTestCase {

    // MARK: init()

    func testInitializerWithBaseUrlOk() {
        let baseUrl = URL(string: "https://www.knowyourmeme.com")
        let client = JSONClient(baseUrl: baseUrl)
        XCTAssertEqual(client.baseUrl, baseUrl)
    }

    func testInitializerWithNilBaseUrlOk() {
        let client = JSONClient(baseUrl: nil)
        XCTAssertNil(client.baseUrl)
    }

    // MARK: get()

    func testGetWithNilBaseUrlAndAbsolutePathOk() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")

        let promise: Promise<DiscogsInfo> = client.get(path: "https://api.discogs.com")

        promise.then { (info) -> Void in
            XCTAssertEqual(info.api_version, "v2")
            XCTAssertEqual(info.documentation_url, URL(string: "http://www.discogs.com/developers/"))
            exp.fulfill()
            }.catch { (error) in
                XCTFail("Failed to get Discogs info: \(error.localizedDescription)")
        }

        wait(for: [exp], timeout: 5.0)
    }

    func testGetWithNilBaseUrlAndRelativePathRejectsPromise() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")
        let path = "relative/path/that/does/not/exist"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a relative path that can't be resolved!")
            }.catch { (error) in
                XCTAssertEqual(error.localizedDescription, "unsupported URL")
                exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithNilBaseUrlAndGarbagePathRejectsPromise() {
        let client = JSONClient(baseUrl: nil)
        let exp = expectation(description: "Discogs info")
        let path = "1(*#%(*DFSLDKU%(*@)"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                XCTAssertTrue(error.localizedDescription.contains("unsupported URL"))
                exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndInvalidPathRejectsPromise() {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let exp = expectation(description: "Discogs info")
        let path = "1(*#%(*DFSLDKU%(*@)"
        let promise: Promise<DiscogsInfo> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                XCTAssertTrue(error.localizedDescription.contains("unsupported URL"))
                exp.fulfill()
       }

        wait(for: [exp], timeout: 1.0)
    }

    func testGetWithValidBaseUrlAndPathButWrongTypeRejectsPromise() {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com")!)
        let exp = expectation(description: "Discogs info")
        let path = "/"
        let promise: Promise<String> = client.get(path: path)
        promise.then { (info) -> Void in
            XCTFail("get() should have failed because it has a nil base URL and a malformed path!")
            }.catch { (error) in
                guard let error = error as? JSONClient.JSONErr else {
                    XCTFail("get() should have failed with a JSONClient.JSONError.invalidUrl error")
                    return
                }

                switch error {
                case .parseFailed:
                    exp.fulfill()
                    break
                default:
                    XCTFail("get() should have failed with a parseFailed error")
                }
        }

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: request()

    func testRequestWithBaseUrlAndPathButNoHeadersOrParamsOk() throws {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let request = try client.request(forPath: "some/path")
        // For some reason, URLComponents always appends a "?", even if there's
        // no query. I can't find this in the documentation anywhere.
        XCTAssertEqual(request.url?.absoluteString, "https://api.discogs.com/some/path?")
        XCTAssertNil(request.allHTTPHeaderFields?.count)
    }

    func testRequestWithBaseUrlAndPathWithHeadersButNoParamsOk() throws {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let headers = ["header1": "foo", "header2": "bar"]
        let request = try client.request(forPath: "some/path", headers: headers)
        XCTAssertEqual(request.url?.absoluteString, "https://api.discogs.com/some/path?")
        XCTAssertEqual(request.allHTTPHeaderFields!.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields!["header1"], "foo")
        XCTAssertEqual(request.allHTTPHeaderFields!["header2"], "bar")
    }

    func testRequestWithBaseUrlAndPathWithHeadersAndParamsOk() throws {
        let client = JSONClient(baseUrl: URL(string: "https://api.discogs.com"))
        let headers = ["header1": "foo", "header2": "bar"]
        let params = [URLQueryItem(name: "foo", value: "foo1"), URLQueryItem(name: "bar", value: "bar2")]
        let request = try client.request(forPath: "some/path", headers: headers, params: params)
        XCTAssertEqual(request.url?.absoluteString, "https://api.discogs.com/some/path?foo=foo1&bar=bar2")
        XCTAssertEqual(request.allHTTPHeaderFields!.count, 2)
        XCTAssertEqual(request.allHTTPHeaderFields!["header1"], "foo")
        XCTAssertEqual(request.allHTTPHeaderFields!["header2"], "bar")
    }

    struct DiscogsInfo: Codable {
        var documentation_url: URL
        var hello: String
        var api_version: String
        var statistics: Stats

        struct Stats: Codable {
            var labels: Int
            var artists: Int
            var releases: Int
        }
    }



}
