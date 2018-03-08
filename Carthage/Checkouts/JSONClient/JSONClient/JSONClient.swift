//  Copyright © 2018 Poikile Creations. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit

/// A REST client that uses OAuth authentication and gets and posts JSON data.
open class JSONClient: NSObject {
    
    public typealias Headers = [String: String]
    public typealias Parameters = [URLQueryItem]
    
    /// Errors that can be thrown by the `JSONClient`. Don't confuse the name
    /// with `Foundation.JSONError`, which are thrown by Foundation parsing
    /// calls.
    public enum JSONErr: Error {
        /// Thrown if a path contains illegal URL characters or is `nil`.
        case invalidUrl(urlString: String?)
        /// Thrown if there's no JSON data at a given path.
        case nilData
        /// Thrown if the JSON at a given path can't be decoded into the
        /// expected type.
        case parseFailed(error: Error)
    }
    
    // MARK: - Properties
    
    /// The root URL for server requests.
    open let baseUrl: URL?

    /// The session that will handle all REST calls.
    open var urlSession: URLSession
    
    // MARK: - Initializers
    
    /// Create the client.
    ///
    /// - parameter baseUrl: The URL against which all relative paths will be
    ///             resolved. If it's `nil`, then paths passed to client's
    ///             methods must be absolute ones.
    public init(baseUrl: URL?) {
        self.baseUrl = baseUrl
        self.urlSession = URLSession(configuration: .default)
        super.init()
    }
    
    // MARK: - REST methods
    
    /// Get the JSON data at the specified path (relative to the `baseUrl`)
    /// and decode it to the expected type.
    ///
    /// - parameter path: The path of the URL, relative to the `baseUrl`, or,
    ///             the absolute URL if `baseUrl` is `nil`.
    /// - parameter headers: Custom header values to use in the request.
    /// - parameter params: Parameter name/value pairs to be appended to the
    ///             URL.
    ///
    /// - throws:   `JSONError.invalidUrl` if `path` contains illegal
    ///             characters, `JSONError.nilData` if `path` is valid,
    ///             but has no content that can be parsed,
    ///             `JSONError.parseFailed` if the JSON at `path` isn't valid
    ///             for the expected type.
    open func get<T: Codable>(path: String,
                              headers: Headers = [:],
                              params: Parameters = []) -> Promise<T> {
        return Promise<T>() { (fulfill, reject) in
            do {
                let urlRequest = try request(forPath: path, headers: headers, params: params)
                
                urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
                    if let error = error {
                        /// Usually an "unsupported URL" `NSError`.
                        reject(error)
                    } else {
                        do {
                            /// Make sure that we got some sort of data.
                            guard let data = data else {
                                reject(JSONErr.nilData)
                                return
                            }
                            
                            /// The data is non-`nil`, so parse it.
                            fulfill(try self.handleSuccessfulData(data))
                        } catch {
                            /// The data couldn't be decoded into the expected
                            /// type `T`.
                            reject(JSONErr.parseFailed(error: error))
                        }
                    }
                    }.resume()  // Kick off the request. Don't forget this!
            } catch {
                reject(error)
            }
        }
    }

    // MARK: - Utility functions
    
    open func handleSuccessfulData<T: Codable>(_ data: Data) throws -> T {
        return try JSONUtils.jsonObject(data: data)
    }

    open func request(forPath path: String,
                      headers: Headers = [:],
                      params: Parameters = []) throws -> URLRequest {
        let initialUrl = URL(string: path, relativeTo: baseUrl)
        var components = URLComponents()
        components.queryItems = params

        guard let url = components.url(relativeTo: initialUrl) else {
            throw JSONErr.invalidUrl(urlString: path)
        }
        
        // Now construct the URLRequest
        var request = URLRequest(url: url)
        headers.forEach { (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
}
