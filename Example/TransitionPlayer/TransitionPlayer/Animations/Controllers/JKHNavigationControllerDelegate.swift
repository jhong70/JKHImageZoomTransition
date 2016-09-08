//
//  JKHNavigationControllerDelegate.swift
//
//  Created by Joon Hong on 8/5/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import Foundation
import UIKit

class JKHNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = toVC as? JKHImageZoomTransitionProtocol, _ = fromVC as? JKHImageZoomTransitionProtocol {
            if operation == .Push {
                return JKHImageZoomAnimationController(type: .In)
            }
            
            return JKHImageZoomAnimationController(type: .Out)
        }
        
       
        return nil
    }
    
}