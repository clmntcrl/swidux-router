//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation

public struct RouteParam {

    public let value: Any
    private let equals: (RouteParam) -> Bool
}

public extension RouteParam {

    init<P: Equatable>(value: P) {
        self.value = value
        self.equals = { param in
            guard let p = param.value as? P else { return false }
            return value == p
        }
    }
}

extension RouteParam: Equatable {

    public static func == (lhs: RouteParam, rhs: RouteParam) -> Bool {
        return lhs.equals(rhs)
    }
}
