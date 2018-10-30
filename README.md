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
    var routeParam: Id<Product>!
    // ...
}
```

Declare your routes:

```swift
enum AppRoute {
    static let home = Route(type: HomeViewController.self)
    static let product: (Id<Product>) -> Route = { Route(type: HomeViewController.self, routeParam: $0) }
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

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

Add the following dependency to your Cartfile:

```
github "clmntcrl/swidux-router" ~> 0.1.1
```

```
$ carthage update
```

You should encounter an issue (something like `Dependency "swidux-router" has no shared framework schemes`) because libraries using SwiftPM are not currently supported by Carthage. This can be resolved with the following: 

```
$ (cd Carthage/Checkouts/swidux-router && swift package generate-xcodeproj --xcconfig-overrides xcode.xcconfig)
$ carthage build swidux-router
```

### [SwiftPM](https://github.com/apple/swift-package-manager)

Add package as dependency:

```swift
import PackageDescription

let package = Package(
    name: "AwesomeProjectNameFramework",
    dependencies: [
        .package(url: "https://github.com/clmntcrl/swidux.git", from: "0.1.0"),
        .package(url: "https://github.com/clmntcrl/swidux-router.git", from: "0.1.1"),
    ],
    targets: [
        .target(name: "AwesomeProjectName", dependencies: ["Swidux", "SwiduxRouter"])
    ]
)
```

Because SwiduxRouter use `UIKit` you need to create a `xcode.xcconfig` containing:

```
SUPPORTED_PLATFORMS = iphoneos iphonesimulator
IPHONEOS_DEPLOYMENT_TARGET = 9.0
```

It override default configuration when generating `xcodeproj`:

```
swift package generate-xcodeproj --xcconfig-overrides xcode.xcconfig
```

Then create an iOS app target `AwesomeProjectName` and scheme. Add `AwesomeProjectNameFramework` as embedded binary, that's it.

## Known issues

- Missing support:
    - `Router.present(_:animated:completion:)`
    - `UITabBarController`
- SwiftPM support is a bit tricky because we cannot add dependency on UIKit

## License

SwiduxRouter is released under the MIT license. See [LICENSE](LICENSE]) for details.
