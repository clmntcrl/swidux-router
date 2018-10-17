//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit

public protocol Routable {

    var route: Route { get }
}

public typealias RoutableViewController = UIViewController & Routable

public extension Routable where Self: UIViewController {

    var route: Route { return Route(type: Self.self) }
}

// MARK: - ParametricRoutable

public protocol ParametricRoutable: Routable {

    associatedtype RouteParameters: Equatable
    var params: RouteParameters! { get set }
}

public typealias ParametricRoutableViewController = UIViewController & ParametricRoutable

public extension ParametricRoutable where Self: UIViewController {

    var route: Route { return Route(type: Self.self, params: self.params) }
}
