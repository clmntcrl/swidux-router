//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit

public struct Route {

    public let type: UIViewController.Type
    public let params: RouteParams?

    public let build: () -> UIViewController
}

public extension Route {

    public init<VC: RoutableViewController>(type: VC.Type = VC.self) {
        self.type = type
        self.params = .none
        self.build = { type.init() }
    }

    public init<VC: ParametricRoutableViewController>(type: VC.Type = VC.self, params: VC.RouteParameters) {
        self.type = type
        self.params = RouteParams(value: params)
        self.build = {
            var vc = type.init()
            vc.params = params
            return vc
        }
    }
}

extension Route: Equatable {

    public static func == (lhs: Route, rhs: Route) -> Bool {
        return lhs.type == rhs.type
            && lhs.params == rhs.params
    }
}

extension Route: CustomStringConvertible {

    public var description: String {
        guard let paramsValue = self.params?.value else {
            return "\(self.type)"
        }
        return "\(self.type)(params: \(paramsValue))"
    }
}
