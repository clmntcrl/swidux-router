//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit

public struct Route {

    public let type: UIViewController.Type
    public let routeParam: RouteParam?

    public let build: () -> UIViewController
}

public extension Route {

    public init<VC: RoutableViewController>(type: VC.Type = VC.self) {
        self.type = type
        self.routeParam = .none
        self.build = { type.init() }
    }

    public init<VC: ParametricRoutableViewController>(type: VC.Type = VC.self, routeParam: VC.RouteParameter) {
        self.type = type
        self.routeParam = RouteParam(value: routeParam)
        self.build = {
            var vc = type.init()
            vc.routeParam = routeParam
            return vc
        }
    }
}

extension Route: Equatable {

    public static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.type == rhs.type
            && lhs.routeParam == rhs.routeParam
    }
}

extension Route: CustomStringConvertible {

    public var description: String {
        guard let paramValue = self.routeParam?.value else {
            return "\(self.type)"
        }
        return "\(self.type)(param: \(paramValue))"
    }
}
