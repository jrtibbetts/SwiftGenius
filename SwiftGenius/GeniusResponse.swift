//  Copyright © 2018 nrith. All rights reserved.

import Foundation

public class GeniusResponse<ResponseType: Codable>: Codable {

    public var meta: Meta!
    public var response: ResponseType?

    /// HTTP response data that's duplicated in the JSON payload.
    public struct Meta: Codable {

        /// The HTTP response status. If it's `200`, there's generally no message.
        public var status: Int

        /// The optional message, e.g. "not found" for a `404` status.
        public var message: String?

    }

}

