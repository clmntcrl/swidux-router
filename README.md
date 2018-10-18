# SwiduxRouter
Router driven by Swidux store.

<img src="http://clmntcrl.io/images/.github/swidux-router/swidux-router-in-action.gif" width="247" />

## Stability

This library should be considered alpha, and not stable. Breaking changes will happen often.

## Usage

Prepare your Swidux store:

```swift
struct AppState {
    var routes = [Route]()
    // ...
}

let store = Store(
    initialState: AppState(),
    reducer: .combine(reducers: [
        routeReducer.lift(\.routes),
        // ...
    ])
)
```

Make your view controllers `Routable` or `ParametricRoutable` if it depends on parameters (for exemple a product page depend on a product id).

```swift
class HomeViewController: Routable {/* ... */}

class ProductViewController: ParametricRoutable {
    var params: Id<Product>!
    // ...
}
```

Declare your routes:

```swift
enum AppRoute {
    static let home = Route(type: HomeViewController.self)
    static let product: (Id<Product>) -> Route = { Route(type: HomeViewController.self, params: $0) }
    // ...
}
```

Init your `Router` and add it to the view controller hierarchy:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window.rootViewController = Router(
            store: store,
            keyPath: \.routes,
            initialRoute: AppRoute.home
        )
        window.makeKeyAndVisible()
        return true
    }
}
```

In order to route to new screens use `store.dispatch` with one of the following route action:  

```swift
enum RouteAction: Action {

    case push(route: Route)
    case back
    case backToRoot
    case backTo(route: Route)
    case reset(routes: [Route])
}
```

## Known issues

- SwiftPM support is broken until we can add dependency on UIKit.

## License

SwiduxRouter is released under the MIT license. See [LICENSE](LICENSE]) for details.
