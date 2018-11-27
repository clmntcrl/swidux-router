import Foundation
import SwiduxRouter

public extension Route {

    public static var coloredRoute: Route {
        return Route(type: ColoredVC.self, routeParam: .random(in: 0...0xffffff))
    }

    public static var blackRoute: Route {
        return Route(type: BlackVC.self)
    }
}

// MARK: - Describing Route

public func describingRoute(_ route: Route) -> String {
    switch route.type {
    case let type where type == Route.coloredRoute.type:
        return "\(type)(param: 0x\(String(route.routeParam!.value as! Int32, radix: 16)))"
    case let type where type == Route.blackRoute.type:
        return "\(route.type)"
    default:
        return "\(route)"
    }
}

// MARK: - Describing RouteDescription

public func describingRoot(_ descriptor: RootDescriptor) -> String {
    let presentedRoute = descriptor.presenting
        .flatMap(describingRoute) ?? "none"
    return "\troutes: [\n\t\t"
        + descriptor.routes
            .map(describingRoute)
            .joined(separator: ",\n\t\t")
        + ",\n\t]\n\tpresenting: \(presentedRoute)"
}
