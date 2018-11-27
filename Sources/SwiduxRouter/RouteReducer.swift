//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import Swidux

public let routeReducer = Reducer<RootDescriptor> { state, action in
    guard let action = action as? RouteAction else { return }

    switch action {
    case .present(let route):
        state.presenting = route
    case .push(let route):
        state.routes += [route]
        state.presenting = .none
    case .back:
        if state.presenting != .none {
            state.presenting = .none
        } else if state.routes.count > 1 {
            state.routes.removeLast()
        }
    case .backToRoot:
        if state.routes.count > 1 {
            state.routes = [ state.routes.first! ]
        }
        state.presenting = .none
    case .backTo(let route):
        guard let routeIndex = state.routes.firstIndex(of: route) else { return }
        state.routes.removeLast(state.routes.count - (routeIndex + 1))
        state.presenting = .none
    case .reset(let routes):
        state.routes = routes
        state.presenting = .none
    }
}
