import Foundation
import UIKit

import Swidux
import SwiduxRouter

public final class ColoredVC: ParametricRoutableViewController {

    public var routeParam: Int32! {
        didSet {
            view.backgroundColor = uicolor(hex: routeParam)
        }
    }

    var label: UILabel!
    var subscription = [Any]()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Build view

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Push",
            style: .plain,
            target: self,
            action: #selector(pushColoredViewController)
        )

        setToolbarItems(
            [
                UIBarButtonItem(
                    title: "Back to root",
                    style: .plain,
                    target: self,
                    action: #selector(backToRoot)
                ),
                UIBarButtonItem(
                    title: "Reset with random route stack",
                    style: .plain,
                    target: self,
                    action: #selector(resetRouterWithRandomRouteStack)
                ),
            ],
            animated: false
        )

        label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentRoute)))
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

        // Subscribe store changes

        subscription = [
            store.subscribe(\.liveViewFrame) { [weak self] frame in self?.view.frame = frame },
            store.subscribe(\.root) { [weak self] root in
                self?.label.text = describingRoot(root)
            }
        ]
    }

    // MARK: - Actions

    @objc private func presentRoute() {
        store.dispatch(RouteAction.present(route: .blackRoute))
    }

    @objc private func backToRoot() {
        store.dispatch(RouteAction.backToRoot)
    }

    @objc private func pushColoredViewController() {
        store.dispatch(RouteAction.push(route: .coloredRoute))
    }

    @objc private func resetRouterWithRandomRouteStack() {
        store.dispatch(
            RouteAction.reset(
                routes: Array(repeating: (), count: Int.random(in: 1...5))
                    .map { _ in  Route.coloredRoute }
            )
        )
    }

    // MARK: - UIColor from hex helper

    private func uicolor(hex: Int32) -> UIColor {
        return UIColor(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: 1
        )
    }
}
