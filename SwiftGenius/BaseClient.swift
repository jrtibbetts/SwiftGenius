//  Copyright © 2018 nrith. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit

open class BaseClient: NSObject {
    
    // MARK: - Properties

    public let userAgent: String
    
    /// The root URL for server requests.
    public let baseUrl: URL
    
    /// The client that handles OAuth authorization and inserts the relevant
    /// headers in calls to the server. Subclasses should assign a value to
    /// this once the user successfully authenticates with the server.
    open var oAuthClient: OAuthSwiftClient?
    
    // MARK: - Initializers
    
    public init(baseUrl: URL,
                userAgent: String) {
        self.baseUrl = baseUrl
        self.userAgent = userAgent
        super.init()
    }
    
    // MARK: - REST methods
    
    public func get<T: Codable>(path: String,
                                headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        let url = URL(string: path, relativeTo: baseUrl)!
        return get(url: url, headers: headers)
    }
    
    public func get<T: Codable>(url: URL,
                                headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            let _ = oAuthClient?.get(url.absoluteString,
                                     parameters: [:],
                                     headers: headers,
                                     success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response: response))
                                        } catch {
                                            reject(error)
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }
    
    public func get<T: Codable>(path: String,
                                headers: OAuthSwift.Headers = [:],
                                pageNumber: Int = 1,
                                resultsPerPage: Int = 50) -> Promise<T> {
        let url = URL(string: path, relativeTo: baseUrl)!
        return get(url: url,
                   headers: headers,
                   pageNumber: pageNumber,
                   resultsPerPage: resultsPerPage)
    }
    
    public func get<T: Codable>(url: URL,
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
            let _ = oAuthClient?.get(url.absoluteString,
                                     parameters: parameters,
                                     headers: headers,
                                     success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response: response))
                                        } catch {
                                            reject(error)
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }
    
    public func post<T: Codable>(url: URL,
                                 headers: OAuthSwift.Headers = [:]) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            let _ = oAuthClient?.post(url.absoluteString,
                                      parameters: [:],
                                      headers: headers,
                                      success: { (response) in
                                        do {
                                            fulfill(try self.handleSuccessfulResponse(response: response))
                                        } catch {
                                            reject(error)
                                        }
            }, failure: { (error) in
                reject(error)
            })
        }
    }
    
    public func post<T: Codable>(url: URL,
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
                                                fulfill(try self.handleSuccessfulResponse(response: response))
                                            } catch {
                                                reject(error)
                                            }
                }, failure: { (error) in
                    reject(error)
                })
            } catch {
                reject(error)
            }
        }
    }
    
    public func handleSuccessfulResponse<T: Codable>(response: OAuthSwiftResponse) throws -> T {
        return try JSONUtils.jsonObject(data: response.data)
    }
    
}
