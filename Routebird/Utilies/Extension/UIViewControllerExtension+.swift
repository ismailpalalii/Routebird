//
//  UIViewControllerExtension+.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: Double = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.alpha = 0

        let width = min(view.frame.width - 40, 280)
        toastLabel.frame = CGRect(x: (view.frame.width - width) / 2,
                                  y: view.frame.height - 130,
                                  width: width,
                                  height: 38)
        view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: [], animations: {
                toastLabel.alpha = 0
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        }
    }
}
