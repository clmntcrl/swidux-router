import Foundation
import UIKit

import Swidux
import SwiduxRouter

public final class ColoredViewController: ParametricRoutableViewController {

    public var params: Int32! {
        didSet {
            view.backgroundColor = uicolor(hex: params)
        }
    }

    var label: UILabel!
    var subscription = [Any]()

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Build view

        let container = UIStackView()
        view.addSubview(container)
        container.axis = .vertical
        container.translatesAutoresizingMaskIntoConstraints = false
        [ NSLayoutConstraint.Attribute.leading, .top, .trailing, .bottom ]
            .map { NSLayoutConstraint(item: container, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0) }
            .forEach { $0.isActive = true }

        label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        container.addArrangedSubview(label)

        let buttons = UIStackView(arrangedSubviews:[
            buildButton(title: "BACK", action: #selector(goBack)),
            buildButton(title: "PUSH", action: #selector(pushColoredViewController)),
            buildButton(title: "RESET", action: #selector(resetRouterWithRandomRouteStack)),
        ])
        buttons.distribution = .fillEqually
        container.addArrangedSubview(buttons)

        // Subscribe store changes

        subscription = [
            store.subscribe(\.liveViewFrame) { [weak self] frame in self?.view.frame = frame },
            store.subscribe(\AppState.routes) { [weak self] routes in
                self.flatMap {
                    $0.label.text = "\troutes: [\n\t\t"
                        + routes
                            .map { "\($0.type)(params: 0x\(String($0.params!.value as! Int32, radix: 16)))" }
                            .joined(separator: ",\n\t\t")
                        + ",\n\t]"
                }
            }
        ]
    }

    private func buildButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Actions

    @objc private func goBack() {
        store.dispatch(RouteAction.back)
    }

    @objc private func pushColoredViewController() {
        store.dispatch(
            RouteAction.push(route: RootRoute.coloredRoute())
        )
    }

    @objc private func resetRouterWithRandomRouteStack() {
        store.dispatch(
            RouteAction.reset(
                routes: Array(repeating: (), count: Int.random(in: 1...5))
                    .map { _ in  RootRoute.coloredRoute() }
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
