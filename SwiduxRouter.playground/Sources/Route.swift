import Foundation

import SwiduxRouter

public extension Route {

    public static var coloredRoute: Route {
        return Route(type: ColoredViewController.self, routeParam: .random(in: 0...0xffffff))
    }
}
