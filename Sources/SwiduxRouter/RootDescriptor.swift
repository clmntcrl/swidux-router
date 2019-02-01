//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation

public struct RootDescriptor {

    public var routes: [Route]
    public var presented: Route? = .none

    public init(routes: [Route], presented: Route? = .none) {
        self.routes = routes
        self.presented = presented
    }
}

public extension RootDescriptor {

    public init(initialRoute: Route) {
        routes = [ initialRoute ]
    }
}

extension RootDescriptor: Equatable {}
