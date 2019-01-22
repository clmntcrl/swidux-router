//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import Swidux

public enum RouteAction: Action {

    case present(Route)
    case push(Route)
    case back
    case backToRoot
    case backTo(Route)
    case reset(RootDescriptor)
}
