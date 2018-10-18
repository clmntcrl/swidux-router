# SwiduxRouter
Router driven by Swidux store.

<img src="http://clmntcrl.io/images/.github/swidux-router/swidux-router-in-action.gif" width="247" />

## Stability

This library should be considered alpha, and not stable. Breaking changes will happen often.

## Supported actions

```swift
public enum RouteAction: Action {

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
