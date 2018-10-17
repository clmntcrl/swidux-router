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
    var subscription: Any!

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = store.state.liveViewFrame


        label = UILabel()
        let maxLabelFrame = CGRect(
            x: 16,
            y: 16,
            width: view.frame.width - 32,
            height: view.frame.height - 32
        )
        label.frame = maxLabelFrame
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        view.addSubview(label)

        subscription = store.subscribe(\AppState.routes) { [weak self] routes in
            self.flatMap {
                $0.label.text = routes
                    .map { "\($0)" }
                    .joined(separator: "\n → ")
                $0.label.frame.size = $0.label.sizeThatFits(maxLabelFrame.size)
            }
        }

        let stack = UIStackView()
        stack.frame.size.width = view.frame.width
        stack.frame.size.height = 64
        stack.center = view.center
        stack.distribution = .fillEqually
        view.addSubview(stack)

        let reset = UIButton(type: .system)
        reset.setTitle("RESET", for: .normal)
        reset.setTitleColor(.white, for: .normal)
        reset.titleLabel?.font = .boldSystemFont(ofSize: 32)
        reset.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        reset.addTarget(self, action: #selector(resetRouter), for: .touchUpInside)
        stack.addArrangedSubview(reset)

        let back = UIButton(type: .system)
        back.setTitle("BACK", for: .normal)
        back.setTitleColor(.white, for: .normal)
        back.titleLabel?.font = .boldSystemFont(ofSize: 32)
        back.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        stack.addArrangedSubview(back)

        let push = UIButton(type: .system)
        push.setTitle("PUSH", for: .normal)
        push.setTitleColor(.white, for: .normal)
        push.titleLabel?.font = .boldSystemFont(ofSize: 32)
        push.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        push.addTarget(self, action: #selector(pushColoredViewController), for: .touchUpInside)
        stack.addArrangedSubview(push)
    }

    private func uicolor(hex: Int32) -> UIColor {
        return UIColor(
            red: CGFloat((hex >> 16) & 0xff) / 255.0,
            green: CGFloat((hex >> 8) & 0xff) / 255.0,
            blue: CGFloat(hex & 0xff) / 255.0,
            alpha: 1
        )
    }

    @objc private func resetRouter() {
        store.dispatch(
            RouteAction.reset(
                routes: Array(repeating: (), count: Int.random(in: 1...5))
                    .map { _ in  RootRoute.coloredRoute() }
            )
        )
    }

    @objc private func goBack() {
        store.dispatch(RouteAction.back)
    }

    @objc private func pushColoredViewController() {
        store.dispatch(
            RouteAction.push(route: RootRoute.coloredRoute())
        )
    }
}
