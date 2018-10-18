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
    case .backToRoot:
        if state.count > 1 {
            state = [ state.first! ]
        }
    case .backTo(let route):
        guard let routeIndex = state.firstIndex(of: route) else { return }
        state.removeLast(state.count - (routeIndex + 1))
    case .reset(let routes):
        state = routes
    }
}
