//
//  UIView+Stylable.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 22.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

protocol Stylable {}

extension UIView: Stylable {}

extension Stylable where Self: UIView {
    @discardableResult
    func disableConstraintsTranslation() -> Self {
        if translatesAutoresizingMaskIntoConstraints {
            translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }

    @discardableResult
    func width(_ constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        disableConstraintsTranslation()
        let constraint = widthAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    func height(_ constant: CGFloat, priority: UILayoutPriority = .required) -> Self {
        disableConstraintsTranslation()
        let constraint = heightAnchor.constraint(equalToConstant: constant)
        constraint.priority = priority
        constraint.isActive = true
        return self
    }

    @discardableResult
    func width(equalTo anchor: NSLayoutDimension) -> Self {
        disableConstraintsTranslation()
        let constraint = widthAnchor.constraint(equalTo: anchor)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func height(equalTo anchor: NSLayoutDimension) -> Self {
        disableConstraintsTranslation()
        let constraint = heightAnchor.constraint(equalTo: anchor)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func top(_ constant: CGFloat = 0, to anchor: NSLayoutYAxisAnchor? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = topAnchor.constraint(equalTo: anchor ?? getSuperView().topAnchor, constant: constant)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func bottom(_ constant: CGFloat = 0, to anchor: NSLayoutYAxisAnchor? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = bottomAnchor.constraint(equalTo: anchor ?? getSuperView().bottomAnchor, constant: -constant)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func leading(_ constant: CGFloat = 0, to anchor: NSLayoutXAxisAnchor? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = leadingAnchor.constraint(equalTo: anchor ?? getSuperView().leadingAnchor, constant: constant)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func trailing(_ constant: CGFloat = 0, to anchor: NSLayoutXAxisAnchor? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = trailingAnchor.constraint(equalTo: anchor ?? getSuperView().trailingAnchor, constant: -constant)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func centerX(_ constant: CGFloat = 0, toView: UIView? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = centerXAnchor.constraint(equalTo: (toView ?? getSuperView()).centerXAnchor, constant: constant)
        constraint.isActive = true
        return self
    }

    @discardableResult
    func centerY(_ constant: CGFloat = 0, toView: UIView? = nil) -> Self {
        disableConstraintsTranslation()
        let constraint = centerYAnchor.constraint(equalTo: (toView ?? getSuperView()).centerYAnchor, constant: constant)
        constraint.isActive = true
        return self
    }

    private func getSuperView() -> UIView {
        guard let superview = superview else {
            fatalError("Constraint cannot be applied because view does not have a superview.")
        }
        return superview
    }
}

