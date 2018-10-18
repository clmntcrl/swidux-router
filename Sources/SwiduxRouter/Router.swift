//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit
import Swidux

public final class Router: UINavigationController {

    private var routeStateSubscription: StoreSubscriptionToken?
    private var dispatchRouteAction: ((RouteAction) -> Void)?

    public convenience init<AppState>(store: Store<AppState>, keyPath: KeyPath<AppState, [Route]>, initialRoute: Route) {
        // Configure router with its initial route
        let initialRoute = initialRoute
        store.dispatch(RouteAction.reset(routes: [initialRoute]))
        self.init(rootViewController: initialRoute.build())
        // Keep reference on store
        self.dispatchRouteAction = { store.dispatch($0) }
        // Subscribe for routes state changes
        routeStateSubscription = store.subscribe(keyPath) { [weak self] routes in
            self?.reflect(newRouteStack: routes)
        }
    }

    private func reflect(newRouteStack newRoutes: [Route]) {
        // Ensure that new route stack cannot be empty
        guard newRoutes.count > 0 else {
            fatalError("Router cannot be empty of routes")
        }
        // Find the lowest common denominator of `currentRoutes` and `newRoutes`.
        let lowestCommonDenominator = viewControllers
            .enumerated()
            .filter {
                guard let routable = $0.element as? RoutableViewController else {
                    fatalError("\($0.element) is not Routable.")
                }
                return $0.offset < newRoutes.count && routable.route == newRoutes[$0.offset]
            }
            .map { $0.element }
        // Route to the right place
        switch lowestCommonDenominator.count {
        case let n where n == newRoutes.count && n == viewControllers.count:
            // Common denominator is equal to the new route stack and also equal to the current route stack. There is nothing to
            // do because new stack and current are equal.
            break
        case let n where n == newRoutes.count:
            // Common denominator is equal to the new route stack. This is the case when new routes are the result of current
            // routes applying some back actions.
            //
            // **Important:** This special case is required to keep pop animation. Indeed, `setViewControllers` method dispatch a
            // `UINavigationController.Operation.push` operation so `UINavigationControllerDelegate` cannot recognize it has a
            // pop operation and can't apply the right animation.
            //
            // **Example:**
            //
            // ```swift
            //     currentRouteDescriptors = [ (route1, vcRoute1), (route2, vcRoute2), ... (routeN, vcRouteN) ]
            //     newRoutes = [ route1, route2 ]
            // ```
            //
            // **NB:** We use `super` implementation of `popToViewController` because Router override `popToViewController` to
            // use Siwdux store and dispatch `RouteAction.backTo(route:)`.
            super.popToViewController(lowestCommonDenominator.last!, animated: true)
        case let n:
            // General case: common denominator has value or not and we have new route(s) to push.
            //
            // **Example:**
            //
            // ```swift
            //     currentRouteDescriptors = [ (route1, vcRoute1), (route2, vcRoute2) ]
            //     newRoutes = [ route1, routeA, routeB ]
            // ```
            //
            // **NB:** We use `super` implementation of `setViewControllers` because Router override `setViewControllers` to
            // use Siwdux store and dispatch `RouteAction.reset(routes:)`.
            let viewControllers = lowestCommonDenominator
                + newRoutes[n...].map { $0.build() }
            super.setViewControllers(viewControllers, animated: true)
        }
    }

    // MARK: - Pop, push, set stack overrides

    // We override popping, pushing and setting stack items methods to rely on Swidux action dispatch (if the Router has been init
    // using `init(store:keyPath:initialRoute:)`, otherwise Router use `super` implementation of those methods).
    //
    // By doing this we are able to handle keep Swidux store synchronized with our view controller stack when:
    //     - hiting the back button of the `NavigationBar`
    //     - using direct call to those methods: `router.popViewController(animated: true)`, ...

    public override func popViewController(animated: Bool) -> UIViewController? {
        guard let dispatch = dispatchRouteAction else { return super.popViewController(animated: animated) }
        dispatch(.back)
        return .none
    }

    public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let dispatch = dispatchRouteAction else { return super.popToRootViewController(animated: animated) }
        dispatch(.backToRoot)
        return .none
    }

    public override func popToViewController(
        _ viewController: UIViewController,
        animated: Bool
    ) -> [UIViewController]? {
        guard let dispatch = dispatchRouteAction else {
            return super.popToViewController(viewController, animated: animated)
        }
        guard let routable = viewController as? RoutableViewController else {
            fatalError("\(viewController) is not Routable.")
        }
        dispatch(.backTo(route: routable.route))
        return .none
    }

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let dispatch = dispatchRouteAction else {
            return super.pushViewController(viewController, animated: animated)
        }
        guard let routable = viewController as? RoutableViewController else {
            fatalError("\(viewController) is not Routable.")
        }
        dispatch(.push(route: routable.route))

    }

    public override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        guard let dispatch = dispatchRouteAction else {
            return super.setViewControllers(viewControllers, animated: animated)
        }
        let routes: [Route] = viewControllers.map {
            guard let routable = $0 as? RoutableViewController else {
                fatalError("\($0) is not Routable.")
            }
            return routable.route
        }
        dispatch(.reset(routes: routes))
    }
}
