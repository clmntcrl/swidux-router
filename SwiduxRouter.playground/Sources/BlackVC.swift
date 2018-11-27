import Foundation
import UIKit

import Swidux
import SwiduxRouter

public final class BlackVC: RoutableViewController {

    var subscription: Any? = .none

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Build view

        view.backgroundColor = .black

        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(back)))
        label.isUserInteractionEnabled = true
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        [ NSLayoutConstraint.Attribute.leading, .top, .trailing, .bottom ]
            .map {
                NSLayoutConstraint(
                    item: label,
                    attribute: $0,
                    relatedBy: .equal,
                    toItem: view,
                    attribute: $0,
                    multiplier: 1,
                    constant: 0
                )
            }
            .forEach { $0.isActive = true }

        // Subscribe store root

        subscription = store.subscribe(\.root) { root in
            label.text = describingRoot(root)
        }
    }

    // MARK: - Actions

    @objc private func back() {
        store.dispatch(RouteAction.back)
    }
}
