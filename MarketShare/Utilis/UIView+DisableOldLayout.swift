import UIKit

extension UIView {
    
    func disableAutoresizingMasks() {
        translatesAutoresizingMaskIntoConstraints = false
        subviews.forEach { $0.disableAutoresizingMasks() }
    }
    
}
