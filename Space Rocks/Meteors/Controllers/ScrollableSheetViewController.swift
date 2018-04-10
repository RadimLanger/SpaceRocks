//
//  ScrollableSheetViewController.swift
//  Space Rocks
//
//  Created by Radim Langer on 08/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

class ScrollableSheetViewController: UIViewController {

    var scrollableContentView: UIScrollView? // MUST be set from outside

    enum Direction {
        case up
        case mid
        case down
        case bottomHiddden
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setFrameInitialValue()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        gesture.delegate = self
        view.addGestureRecognizer(gesture)
    }

    private let fullSizeYPadding: CGFloat = 100
    private(set) lazy var middleSizeYPadding: CGFloat = (superViewHeight / 2)
    private(set) lazy var partialSizeYPadding: CGFloat = superViewHeight - 150

    private var superViewHeight: CGFloat {
        guard let superViewHeight = view.superview?.bounds.size.height
            else {
                fatalError("superview height was called too early")
        }
        return superViewHeight
    }

    func setFrameInitialValue(rect: CGRect? = nil) {
        view.frame = rect ?? CGRect(x: 0, y: UIScreen.main.bounds.height, width: view.frame.width, height: 0)
    }

    func animateSheetView(direction: Direction, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {

        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: [.allowUserInteraction],
            animations: {

                let y: CGFloat

                switch direction {
                    case .up:            y = self.fullSizeYPadding
                    case .mid:           y = self.middleSizeYPadding
                    case .down:          y = self.partialSizeYPadding
                    case .bottomHiddden: y = self.superViewHeight
                }

                self.view.frame = CGRect(
                    x: 0,
                    y: y,
                    width: self.view.frame.width,
                    height: self.superViewHeight
                )

        }, completion: { _ in
            completion?()
        })
    }

    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {

        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)

        let minY = self.view.frame.minY

        if (minY + translation.y >= fullSizeYPadding) && (minY + translation.y <= partialSizeYPadding) {
            self.view.frame = CGRect(
                x: 0,
                y: minY + translation.y,
                width: self.view.frame.width,
                height: superViewHeight
            )
            recognizer.setTranslation(.zero, in: self.view)
        }

        if recognizer.state == .ended {
            var duration = velocity.y < 0
                ? (minY - fullSizeYPadding) / -velocity.y
                : (partialSizeYPadding - minY) / velocity.y

            duration = min(duration, 1.3)

            let direction: Direction

            let lastFingerYPoint = view.convert(translation, to: view.superview).y

            if velocity.y >= 0 {
                direction = lastFingerYPoint <= middleSizeYPadding ? .mid : .down
            } else {
                direction = lastFingerYPoint >= middleSizeYPadding ? .mid : .up
            }

            animateSheetView(direction: direction, duration: Double(duration))
        }
    }
}

extension ScrollableSheetViewController {

    //effect view
    func addBlurEffectView(){
        let blurEffect = UIBlurEffect(style: .dark)

        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = view.bounds
        view.insertSubview(blurEffectView, at: 0)
    }
}

extension ScrollableSheetViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {

        guard
            let gesture = gestureRecognizer as? UIPanGestureRecognizer,
            let scrollView = scrollableContentView
        else {
            return false
        }

        let direction = gesture.velocity(in: view).y
        let y = view.frame.minY
        let isInLimit = y == fullSizeYPadding && scrollView.contentOffset.y == 0 && direction > 0
        let isScrollEnabled = isInLimit || (y >= middleSizeYPadding) ? false : true

        scrollView.isScrollEnabled = isScrollEnabled

        return false
    }
}
