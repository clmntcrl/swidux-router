# SwiduxRouter
Router driven by Swidux store.

<img src="http://clmntcrl.io/images/.github/swidux-router/swidux-router-in-action.gif#1" width="247" />

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

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

Add the following dependency to your `Cartfile`:

```ruby
github "clmntcrl/swidux-router" ~> 0.2
```

### [CocoaPods](https://cocoapods.org)

Add the following pod to your `Podfile`:

```ruby
pod 'SwiduxRouter', '~> 0.2'
```

### [SwiftPM](https://github.com/apple/swift-package-manager)

Add the package as dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/clmntcrl/swidux-router.git", from: "0.2.0"),
]
```

Create a `xcode.xcconfig` file, with the following content:

```
SUPPORTED_PLATFORMS = iphoneos iphonesimulator
IPHONEOS_DEPLOYMENT_TARGET = 10.0
```

Generate `.xcodeproj`:

```
swift package generate-xcodeproj --xcconfig-overrides xcode.xcconfig
```

## License

SwiduxRouter is released under the MIT license. See [LICENSE](LICENSE]) for details.
