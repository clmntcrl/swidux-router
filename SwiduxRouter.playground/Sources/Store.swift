import Foundation
import UIKit

import Swidux
import SwiduxRouter

public struct AppState {
    public var root = RootDescriptor(initialRoute: .coloredRoute)
    public var liveViewFrame = CGRect(x: 0, y: 0, width: 375, height: 667)
}

public let store = Store(
    initialState: AppState(),
    reducer: routeReducer.lift(\.root)
)

