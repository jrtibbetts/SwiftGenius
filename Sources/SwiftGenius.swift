//  Copyright © 2021 Poikile Creations. All rights reserved.

import Foundation
import Stylobate

/// An empty class that can be used to get the Medi8 bundle.
public class SwiftGenius: NSObject {

    public static var bundle = Stylobate.resourceBundle(named: "SwiftGenius_SwiftGenius",
                                                        sourceBundle: Bundle(for: SwiftGenius.self))

}
