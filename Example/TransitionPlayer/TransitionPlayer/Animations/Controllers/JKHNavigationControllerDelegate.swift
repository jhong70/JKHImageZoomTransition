//
//  JKHNavigationControllerDelegate.swift
//
//  Created by Joon Hong on 8/5/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import Foundation
import UIKit

class JKHNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let _ = toVC as? JKHImageZoomTransitionProtocol, let _ = fromVC as? JKHImageZoomTransitionProtocol {
            if operation == .push {
                return JKHImageZoomAnimationController(type: .inward)
            }
            
            return JKHImageZoomAnimationController(type: .outward)
        }
        
       
        return nil
    }
    
}
