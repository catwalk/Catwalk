//
//  CTWAssistantNavigationController.swift
//  Copyright © 2021 CATWALK. All rights reserved.
//

import UIKit

class CTWAssistantNavigationController: UINavigationController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if(completion == nil) {
            endSession()
        }
        super.dismiss(animated: flag, completion: completion)
    }
    
    private func endSession() {
        CTWNetworkManager.shared.endSession { (result: Result<CTWDefaultResponse, CTWNetworkManager.APIServiceError>) in
            GenieAPI.sessionId = ""
        }
    }
}
