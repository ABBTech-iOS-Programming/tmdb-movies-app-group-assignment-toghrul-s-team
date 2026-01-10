import UIKit

extension UILabel {
    func applyInnerShadow() {
        // köhnə inner shadow-u sil
        layer.sublayers?
            .filter { $0.name == "innerShadow" }
            .forEach { $0.removeFromSuperlayer() }

        let innerShadow = CALayer()
        innerShadow.name = "innerShadow"
        innerShadow.frame = bounds

        let path = UIBezierPath(rect: bounds.insetBy(dx: -10, dy: -10))
        let cutout = UIBezierPath(rect: bounds).reversing()
        path.append(cutout)

        innerShadow.shadowPath = path.cgPath
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 4)
        innerShadow.shadowOpacity = 0.25
        innerShadow.shadowRadius = 4

        layer.addSublayer(innerShadow)
    }
}
