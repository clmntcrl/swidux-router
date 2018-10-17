//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import Swidux

public let routeReducer = Reducer<[Route]> { state, action in
    guard let action = action as? RouteAction else { return }

    switch action {
    case .push(let route):
        state += [route]
    case .back:
        if state.count > 1 {
            state.removeLast()
        }
    case .reset(let routes):
        state = routes
    }
}
