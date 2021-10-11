//
//  CTWAssistantContext.swift
//  Catwalk
//
//  Created by CTWLK on 8/15/21.
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

public class CTWAssistantContext {
    public var delegate: CTWAssistantDelegate?
    public var focusedSKU: String?
    public var hostViewController: UIViewController?
    
    public init() {}
    
    public func presentAssistant() {
        let genieViewController = CTWGenieViewController(focusedSKU: focusedSKU)
        let navigationViewController = CTWAssistantNavigationController(rootViewController: genieViewController)
        genieViewController.delegate = delegate
        navigationViewController.modalPresentationStyle = .overCurrentContext
        hostViewController?.present(navigationViewController, animated: true)
    }
    
    public func presentOfflineState() {
        let genieViewController = CTWOfflineStateViewController()
        genieViewController.modalPresentationStyle = .overCurrentContext
        hostViewController?.present(genieViewController, animated: true)
    }
    
    public static func shouldShowItem(sku: String, completion: @escaping (Bool) -> Void) {
        CTWNetworkManager.shared.checkItemAvailability(sku: sku, showCheck: true) { (result: Result<CTWAvailability, CTWNetworkManager.APIServiceError>) in
            switch result {
                case .success(let availability):
                    completion(availability.available ?? false)
                case .failure( _):
                    completion(false)
            }
        }
    }
}
