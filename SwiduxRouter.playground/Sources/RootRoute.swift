import Foundation

import SwiduxRouter

public enum RootRoute {

    public static let coloredRoute: () -> Route = {
        Route(type: ColoredViewController.self, params: .random(in: 0...Int32.max))
    }
}
