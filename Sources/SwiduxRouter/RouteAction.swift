//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import Swidux

public enum RouteAction: Action {

    case push(route: Route)
    case back
    case backToRoot
    case backTo(route: Route)
    case reset(routes: [Route])
}
