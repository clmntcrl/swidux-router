# SwiduxRouter
Router driven by Swidux store.

<img src="http://clmntcrl.io/images/.github/swidux-router/swidux-router-in-action.gif#1" width="247" />

## Stability

This library should be considered alpha, and not stable. Breaking changes will happen often.

## Usage

Declare your routes:

```swift
extension Route {
    static let home = Route(type: HomeViewController.self)
    static let product: (Id<Product>) -> Route = { Route(type: HomeViewController.self, routeParam: $0) }
    // ...
}
```

Prepare your Swidux store defining initial route:

```swift
struct AppState {
    var root = RootDescriptor(initialRoute: .home)
    // ...
}

let store = Store(
    initialState: AppState(),
    reducer: .combine(reducers: [
        routeReducer.lift(\.root),
        // ...
    ])
)
```

Make your view controllers `Routable` or `ParametricRoutable` if it depends on parameters (for exemple a product page depend on a product id).

```swift
class HomeViewController: Routable {/* ... */}

class ProductViewController: ParametricRoutable {
    var routeParam: Id<Product>!
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
            keyPath: \.root
        )
        window.makeKeyAndVisible()
        return true
    }
}
```

In order to route to new screens use `store.dispatch` with one of the following route action:  

```swift
enum RouteAction: Action {
    case present(Route)
    case push(Route)
    case back
    case backToRoot
    case backTo(Route)
    case reset(RootDescriptor)
}
```

## Known issues

- Missing support for `UITabBarController`

## License

SwiduxRouter is released under the MIT license. See [LICENSE](LICENSE]) for details.
