//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit

public protocol ParametricRoutable: Routable {

    associatedtype RouteParameter: Equatable
    var routeParam: RouteParameter! { get set }
}

public typealias ParametricRoutableViewController = UIViewController & ParametricRoutable

public extension ParametricRoutable where Self: UIViewController {

    var route: Route { return Route(type: Self.self, routeParam: self.routeParam) }
}
