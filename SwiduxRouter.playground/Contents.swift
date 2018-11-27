import PlaygroundSupport
import UIKit

import Swidux
import SwiduxRouter

let router = Router(
    store: store,
    keyPath: \.root
)
router.isToolbarHidden = false
router.view.frame = store.state.liveViewFrame

PlaygroundPage.current.liveView = router.view

print("✅")
