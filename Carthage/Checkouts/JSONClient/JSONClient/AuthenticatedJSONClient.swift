//  Copyright © 2018 Poikile Creations. All rights reserved.

import OAuthSwift
import PromiseKit
import UIKit

open class AuthenticatedJSONClient: JSONClient {

    // MARK: - Properties

    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    open var oAuthClient: OAuthSwiftClient?

    // MARK: - REST methods

    open func authenticatedGet<T: Codable>(path: String,
                                           headers: OAuthSwift.Headers = [:],
                                           pageNumber: Int = 1,
                                           resultsPerPage: Int = 50) -> Promise<T> {
        let url = URL(string: path, relativeTo: baseUrl)
        return authenticatedGet(url: url,
                                headers: headers,
                                pageNumber: pageNumber,
                                resultsPerPage: resultsPerPage)
    }

    open func authenticatedGet<T: Codable>(url: URL?,
                                           headers: OAuthSwift.Headers = [:],
                                           pageNumber: Int = 1,
                                           resultsPerPage: Int = 50) -> Promise<T> {
        let parameters: OAuthSwift.Parameters

        if pageNumber == 0 {
            parameters = [:]
        } else {
            parameters = ["page" : String(pageNumber), "per_page" : String(resultsPerPage)]
        }

        return Promise<T>() { (fulfill, reject) in
            guard let absoluteUrl = url?.absoluteString else {
                reject(JSONErr.invalidUrl(urlString: url?.relativeString ?? "nil URL"))
                return
            }

            let _ = oAuthClient?.get(absoluteUrl,
                                     parameters: parameters,
                                     headers: headers,
                                     success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response))
                                        } catch {
                                            reject(JSONErr.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }

    open func authenticatedPost<T: Codable>(url: URL,
                                            headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            let _ = oAuthClient?.post(url.absoluteString,
                                      parameters: [:],
                                      headers: headers,
                                      success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response))
                                        } catch {
                                            reject(JSONErr.parseFailed(error: error))
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }

    open func authenticatedPost<T: Codable>(url: URL,
                                            object: T,
                                            headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            do {
                let data = try JSONUtils.jsonData(forObject: object)

                let _ = oAuthClient?.post(url.absoluteString,
                                          parameters: [:],
                                          headers: headers,
                                          body: data,
                                          success: { (response) in
                                            do {
                                                fulfill(try self.handleSuccessfulResponse(response))
                                            } catch {
                                                reject(JSONErr.parseFailed(error: error))
                                            }
                }, failure: { (error) in
                    reject(error)
                })
            } catch {
                reject(error)
            }
        }
    }

    // MARK: - Utility functions

    open func handleSuccessfulResponse<T: Codable>(_ response: OAuthSwiftResponse) throws -> T {
        return try handleSuccessfulData(response.data)
    }

}
