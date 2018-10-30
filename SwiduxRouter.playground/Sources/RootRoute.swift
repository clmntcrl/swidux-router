import Foundation

import SwiduxRouter

public enum RootRoute {

    public static let coloredRoute: () -> Route = {
        Route(type: ColoredViewController.self, routeParam: .random(in: 0...0xffffff))
    }
}
