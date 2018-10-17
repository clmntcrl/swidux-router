//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation

public struct RouteParams {

    public let value: Any
    private let equals: (RouteParams) -> Bool
}

public extension RouteParams {

    init<P: Equatable>(value: P) {
        self.value = value
        self.equals = { params in
            guard let p = params.value as? P else { return false }
            return value == p
        }
    }
}

extension RouteParams: Equatable {

    public static func == (lhs: RouteParams, rhs: RouteParams) -> Bool {
        return lhs.equals(rhs)
    }
}
