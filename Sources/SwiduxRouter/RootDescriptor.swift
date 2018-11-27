//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation

public struct RootDescriptor {

    public var routes: [Route]
    public var presenting: Route? = .none

    public init(routes: [Route], presenting: Route? = .none) {
        self.routes = routes
        self.presenting = presenting
    }
}

public extension RootDescriptor {

    public init(initialRoute: Route) {
        routes = [ initialRoute ]
    }
}

extension RootDescriptor: Equatable {}
