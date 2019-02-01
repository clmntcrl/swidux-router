import PlaygroundSupport
import UIKit

import Swidux
import SwiduxRouter

let router = Router(
    store: store,
    keyPath: \.root
)
router.isToolbarHidden = false
router.view.frame = store.getState().liveViewFrame

PlaygroundPage.current.liveView = router.view

print("✅")
