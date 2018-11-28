//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import Swidux

public let routeReducer = Reducer<RootDescriptor> { state, action in
    guard let action = action as? RouteAction else { return }

    switch action {
    case .present(let route):
        state.presented = route
    case .push(let route):
        state.routes += [route]
        state.presented = .none
    case .back:
        if state.presented != .none {
            state.presented = .none
        } else if state.routes.count > 1 {
            state.routes.removeLast()
        }
    case .backToRoot:
        if state.routes.count > 1 {
            state.routes = [ state.routes.first! ]
        }
        state.presented = .none
    case .backTo(let route):
        guard let routeIndex = state.routes.firstIndex(of: route) else { return }
        state.routes.removeLast(state.routes.count - (routeIndex + 1))
        state.presented = .none
    case .reset(let rootDescriptor):
        state = rootDescriptor
    }
}
