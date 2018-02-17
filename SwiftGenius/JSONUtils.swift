//  Copyright © 2017 nrith. All rights reserved.

import Foundation

/// Types for JSON encoding and decoding errors.
public enum JSONFileLoadingError: Error {

    /// Thrown when no file of the specified name and extension was found in
    /// a bundle.
    case fileNotFound(fileName: String, type: String, bundle: Bundle)
}

/// A collection of static utility functions for encoding and decoding JSON
/// data.
public struct JSONUtils {

    // MARK: - Private properties

    /// The decoder that all decoding functions use. It uses the default
    /// decoding strategies.
    fileprivate static let decoder = JSONDecoder()

    /// The encoder that all encoding functions use. It uses the default
    /// encoding strategies.
    fileprivate static let encoder = JSONEncoder()

    // MARK: - Encoding functions

    /// Encode an object into JSON data.
    ///
    /// - parameter object: The `Encodable` object.
    ///
    /// - throws:   An error if the object couldn't be encoded properly.
    ///
    /// - returns:  The JSON `Data` for the encodable object.
    public static func jsonData<T: Encodable>(forObject object: T) throws -> Data {
        return try encoder.encode(object)
    }

    // MARK: - Decoding functions

    /// Decode JSON data. This is really just a shortcut that calls
    /// `JSONDecoder.decode(_:data)` without specifying the target type, which
    /// can be inferred from the return type.
    ///
    /// - parameter data: The JSON data.
    ///
    /// - throws:   Errors if no valid `Data` was found at the specified `URL`,
    ///             or if the data couldn't be decoded into a valid object.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(data: Data) throws -> T {
        return try decoder.decode(T.self, from: data)
    }

    /// Decode the JSON data at a specified URL.
    ///
    /// - parameter atUrl: The `URL` of the JSON data.
    ///
    /// - throws:   Errors if no valid `Data` was found at the specified `URL`,
    ///             or if the data couldn't be decoded into a valid object.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(atUrl jsonUrl: URL) throws -> T {
        return try jsonObject(data: Data(contentsOf: jsonUrl))
    }

    /// Decode the JSON data in a specified local file.
    ///
    /// - parameter atUrl: The `URL` of the JSON data.
    ///
    /// - parameter forFileNamed: The name of the file, *without* an extension.
    /// - parameter ofType: The extension of the file. The default is `json`.
    /// - parameter inBundle: The resource bundle in which the file is found.
    ///             The default is `Bundle.main`.
    ///
    /// - returns:  The `Codable` object parsed from the JSON data.
    public static func jsonObject<T: Decodable>(forFileNamed fileName: String,
                                                ofType fileType: String = "json",
                                                inBundle bundle: Bundle = Bundle.main) throws -> T {
        return try jsonObject(atUrl: url(forFileNamed: fileName, ofType: fileType, inBundle: bundle))
    }

    /// Get a local URL for a file of a specified type in a bundle.
    ///
    /// - parameter forFileNamed: The name of the file, *without* an extension.
    /// - parameter ofType: The extension of the file. The default is `json`.
    /// - parameter inBundle: The resource bundle in which the file is found.
    ///             The default is `Bundle.main`.
    ///
    /// - throws:   `JSONFileLoadingError.fileNotFound` if the specified file
    ///             isn't in the specified bundle.
    ///
    /// - returns:  A `URL` for the specified local file.
    public static func url(forFileNamed fileName: String,
                           ofType fileType: String = "json",
                           inBundle bundle: Bundle = Bundle.main) throws -> URL {
        guard let jsonFilePath = bundle.path(forResource: fileName, ofType: fileType) else {
            throw JSONFileLoadingError.fileNotFound(fileName: fileName, type: fileType, bundle: bundle)
        }

        return URL(fileURLWithPath: jsonFilePath)
    }

}
