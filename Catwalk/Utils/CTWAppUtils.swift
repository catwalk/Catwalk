//
//  CTWAppUtils.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWAppUtils {
    static func formatNumberToDecimal(value:Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "pt_BR")
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:value)) ?? "Valor indefinido"
    }
    
    static func createLoader(title: String) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .medium
        } else {
            loadingIndicator.style = .whiteLarge
            loadingIndicator.color = .gray
        }
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        return alert
    }
    
    static func showAlert(title: String, message: String, host: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        host?.present(alert, animated: true, completion: nil)
    }
}
