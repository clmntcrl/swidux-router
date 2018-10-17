//  Created by Cyril Clément
//  Copyright © 2018 clmntcrl. All rights reserved.

import Foundation
import UIKit
import Swidux

public final class Router: UINavigationController {

    private var routeStateSubscription: StoreSubscriptionToken!

    public convenience init<AppState>(store: Store<AppState>, keyPath: KeyPath<AppState, [Route]>, initialRoute: Route) {
        // Configure router with its initial route
        let initialRoute = initialRoute
        store.dispatch(RouteAction.reset(routes: [initialRoute]))
        self.init(rootViewController: initialRoute.build())
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
        case let n
            where n == newRoutes.count && n == viewControllers.count:
            // Common denominator is equal to the new route stack and also equal to the current route stack. There is nothing to
            // do because new stack and current are equal.
            break
        case let n
            where n == newRoutes.count:
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
            popToViewController(lowestCommonDenominator.last!, animated: true)
        case let n:
            // General case: common denominator has value or not and we have new route(s) to push.
            //
            // **Example:**
            //
            // ```swift
            //     currentRouteDescriptors = [ (route1, vcRoute1), (route2, vcRoute2) ]
            //     newRoutes = [ route1, routeA, routeB ]
            // ```
            let viewControllers = lowestCommonDenominator
                + newRoutes[n...].map { $0.build() }
            setViewControllers(viewControllers, animated: true)
        }
    }
}
