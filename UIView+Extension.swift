import Foundation
import UIKit

public enum ViewAxisConstraints: String {
    case top = "topConstraint"
    case bottom = "bottomConstraint"
    case leading = "leadingConstraint"
    case trailing = "trailingConstraint"
    case centerX = "centerXConstraint"
    case centerY = "centerYConstraint"
}

public enum ViewDimensionConstraints: String {
    case width = "widthConstraint"
    case height = "heightConstraint"
}

public enum AxisYReference {
    case top
    case bottom
}

public enum AxisXReference {
    case leading
    case trailing
}

public extension UIView {
    
    // MARK: - Axis Constraints
    
    @discardableResult func vertical(_ refence: AxisYReference, to anchor: NSLayoutYAxisAnchor? = nil, constant: CGFloat = .zero) -> UIView {
        let viewAnchor = refence == .top ? topAnchor : bottomAnchor
        if let referenceAnchor = anchor ?? (refence == .top ? superview?.topAnchor : superview?.bottomAnchor) {
            setLayoutAnchor(forYAxis: (viewAnchor, referenceAnchor),
                            constant: constant,
                            identifier: ViewAxisConstraints.top.rawValue)
        }
        return self
    }
    
    @discardableResult func horizontal(_ refence: AxisXReference, to anchor: NSLayoutXAxisAnchor? = nil, constant: CGFloat = .zero) -> UIView {
        let viewAnchor = refence == .leading ? leadingAnchor : trailingAnchor
        if let referenceAnchor = anchor ?? (refence == .leading ? superview?.leadingAnchor : superview?.trailingAnchor) {
            setLayoutAnchor(forXAxis: (viewAnchor, referenceAnchor),
                            constant: constant,
                            identifier: ViewAxisConstraints.leading.rawValue)
        }
        return self
    }
    
    func constraintToSuperview() {
        vertical(.top)
        vertical(.bottom)
        horizontal(.leading)
        horizontal(.trailing)
    }
        
    // MARK: - Axis Constraints References
    
    var topConstraint: NSLayoutConstraint? {
        constraintFromSuperview(withIdentifier: ViewAxisConstraints.top.rawValue)
    }
    var bottomConstraint: NSLayoutConstraint? {
        constraintFromSuperview(withIdentifier: ViewAxisConstraints.bottom.rawValue)
    }
    var leadingConstraint: NSLayoutConstraint? {
        constraintFromSuperview(withIdentifier: ViewAxisConstraints.leading.rawValue)
    }
    var trailingConstraint: NSLayoutConstraint? {
        constraintFromSuperview(withIdentifier: ViewAxisConstraints.trailing.rawValue)
    }
    
    // MARK: - Dimensions Constraints
    
    @discardableResult func height(_ constraint: NSLayoutDimension? = nil, multiplier: CGFloat? = 1, constant: CGFloat = .zero) -> UIView {
        setDimensionAnchor(for: heightAnchor,
                           to: constraint,
                           multiplier: multiplier,
                           constant: constant,
                           identifier: ViewDimensionConstraints.height.rawValue)
        return self
    }
    
    @discardableResult func width(_ constraint: NSLayoutDimension? = nil, multiplier: CGFloat? = 1, constant: CGFloat = .zero) -> UIView {
        setDimensionAnchor(for: widthAnchor,
                           to: constraint,
                           multiplier: multiplier,
                           constant: constant,
                           identifier: ViewDimensionConstraints.width.rawValue)
        return self
    }
    
    @discardableResult func size(_ constant: CGFloat) -> UIView {
        setDimensionAnchor(for: heightAnchor, constant: constant, identifier: ViewDimensionConstraints.height.rawValue)
        setDimensionAnchor(for: widthAnchor, constant: constant, identifier: ViewDimensionConstraints.width.rawValue)
        return self
    }
    
    // MARK: - Dimensions Constraints References
    
    var heightConstraint: NSLayoutConstraint? {
        constraints.first { $0.identifier == ViewDimensionConstraints.height.rawValue }
    }
    
    var widthConstraint: NSLayoutConstraint? {
        constraints.first { $0.identifier == ViewDimensionConstraints.width.rawValue }
    }
    
    // MARK: - Align Constraints
    
    @discardableResult func centerX(_ offset: CGFloat = .zero, to anchor: NSLayoutXAxisAnchor? = nil) -> UIView {
        guard let referenceAnchor = anchor ?? superview?.centerXAnchor else {
            return self
        }
        setLayoutAnchor(forXAxis: (centerXAnchor, referenceAnchor), constant: offset, identifier: ViewAxisConstraints.centerX.rawValue)
        return self
    }

    @discardableResult func centerY(_ offset: CGFloat = .zero, to anchor: NSLayoutYAxisAnchor? = nil) -> UIView {
        guard let referenceAnchor = anchor ?? superview?.centerYAnchor else {
            return self
        }
        setLayoutAnchor(forYAxis: (centerYAnchor, referenceAnchor), constant: offset, identifier: ViewAxisConstraints.centerY.rawValue)
        return self
    }
    
    @discardableResult func centerXY() -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerX().centerY()
        return self
    }
    
    // MARK: - Private (Helpers)
    private func constraintFromSuperview(withIdentifier identifier: String) -> NSLayoutConstraint? {
        superview?.constraints.first {
            ($0.firstItem as? UIView == self || $0.secondItem as? UIView == self) && $0.identifier == identifier
        }
    }
    
    private func setLayoutAnchor(forXAxis xAxis: (NSLayoutAnchor<NSLayoutXAxisAnchor>, NSLayoutAnchor<NSLayoutXAxisAnchor>)? = nil,
                                 forYAxis yAxis: (NSLayoutAnchor<NSLayoutYAxisAnchor>, NSLayoutAnchor<NSLayoutYAxisAnchor>)? = nil,
                                 constant: CGFloat = .zero,
                                 identifier: String) {
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraint: NSLayoutConstraint
        
        if let xAxis = xAxis {
            constraint = xAxis.0.constraint(equalTo: xAxis.1, constant: constant)
        } else if let yAxis = yAxis {
            constraint = yAxis.0.constraint(equalTo: yAxis.1, constant: constant)
        } else {
            return
        }
    
        constraint.identifier = identifier
        constraint.isActive = true
    }
    
    private func setDimensionAnchor(for primaryAnchor: NSLayoutDimension,
                                    to referenceAnchor: NSLayoutDimension? = nil,
                                    multiplier: CGFloat? = 1,
                                    constant: CGFloat = .zero,
                                    identifier: String) {
        
        translatesAutoresizingMaskIntoConstraints = false
        var constraint: NSLayoutConstraint
        
        if let referenceAnchor = referenceAnchor, let multiplier = multiplier {
            constraint = primaryAnchor.constraint(equalTo: referenceAnchor, multiplier: multiplier, constant: constant)
        } else {
            constraint = primaryAnchor.constraint(equalToConstant: constant)
        }
        
        constraint.identifier = identifier
        constraint.isActive = true
    }
}
