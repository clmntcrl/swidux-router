import PlaygroundSupport
import UIKit

import Swidux
import SwiduxRouter

let router = Router(
    store: store,
    keyPath: \.routes,
    initialRoute: RootRoute.coloredRoute()
)
router.setNavigationBarHidden(true, animated: false)
router.view.frame = store.state.liveViewFrame

PlaygroundPage.current.liveView = router.view
