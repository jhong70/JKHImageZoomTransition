//
//  JKHImageZoomAnimationController.swift
//
//  Created by Joon Hong on 8/4/16.
//  Copyright © 2016 Joon Ki Hong. All rights reserved.
//

import Foundation
import UIKit

@objc protocol JKHImageZoomTransitionProtocol {
    @objc optional func transitionFromImageView() -> UIImageView
    @objc optional func transitionToImageView() -> UIImageView
    @objc optional func transitionDidFinish(_ completed: Bool, finalImage: UIImage)
}

class JKHImageZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum JKHImageZoomType {
        case inward
        case outward
    }
    
    var backgroundColor: UIColor
    var viewContentMode: UIViewContentMode
    var duration: TimeInterval
    var springVelocity: CGFloat
    var springDamping: CGFloat
    var type: JKHImageZoomType
    
    init(type: JKHImageZoomType, backgroundColor: UIColor = UIColor.white, viewContentMode: UIViewContentMode = .scaleAspectFill, duration: TimeInterval = 0.7, springVelocity: CGFloat = 1.5, springDamping: CGFloat = 1.0) {
        self.backgroundColor = backgroundColor
        self.viewContentMode = viewContentMode
        self.duration = duration
        self.springVelocity = springVelocity
        self.springDamping = springDamping
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        var tabBar: UITabBar?
        
        guard var toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            var fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                return
        }
        
        // Account for navigation and tab bar controllers
        if fromVC is UINavigationController {
            fromVC = (fromVC as! UINavigationController).topViewController!
        }
        if toVC is UINavigationController {
            toVC = (toVC as! UINavigationController).topViewController!
        }
        if fromVC is UITabBarController {
            fromVC = (fromVC as! UITabBarController).selectedViewController!
        }
        if toVC is UITabBarController {
            tabBar = (toVC as! UITabBarController).tabBar
            tabBar!.transform = CGAffineTransform(translationX: 0, y: tabBar!.frame.origin.y)
            toVC = (toVC as! UITabBarController).selectedViewController!
        }
        
        containerView.backgroundColor = backgroundColor
        containerView.addSubview(toView)
        containerView.addSubview(fromView)
        
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        let fromImageView = (fromVC as! JKHImageZoomTransitionProtocol).transitionFromImageView!()
        let fromImageViewCopy = UIImageView(image: fromImageView.image)
        let toImageView = (toVC as! JKHImageZoomTransitionProtocol).transitionToImageView!()
        let toImageViewFrame = containerView.convert(toImageView.frame, from: toImageView.superview)
        
        fromImageViewCopy.contentMode = viewContentMode
        fromImageViewCopy.clipsToBounds = true
        fromImageViewCopy.frame = containerView.convert(fromImageView.frame, from: fromImageView.superview)
        
        containerView.addSubview(fromImageViewCopy)
        
        let fromAnchorPoint = CGPoint(x: fromImageViewCopy.center.x/containerView.frame.size.width, y: fromImageViewCopy.center.y/containerView.frame.size.height)
        let toAnchorPoint = CGPoint(x: toImageViewFrame.midX/containerView.frame.size.width, y: toImageViewFrame.midY/containerView.frame.size.height)
        let transforms = transformsForZoom(withType: type, toFrame: toImageViewFrame, fromFrame: fromImageViewCopy.frame)
        
        setAnchorPoint(fromAnchorPoint, forView: fromView)
        setAnchorPoint(toAnchorPoint, forView: toView)
        
        toView.transform = transforms.to
        
        self.animate(withTransitionContext: transitionContext, animations: {
            fromImageViewCopy.frame = toImageViewFrame
            fromView.alpha = 0
            fromView.transform = transforms.from
            toView.transform = .identity
        }) { (completed) in
            toView.layer.position = toView.center
            fromView.alpha = 1
            fromView.transform = .identity
            fromImageViewCopy.removeFromSuperview()
            fromView.removeFromSuperview()
            
            if tabBar != nil { // Animate the tab bar after animation
                self.animate(withTransitionContext: transitionContext, animations: {
                    tabBar?.transform = CGAffineTransform.identity
                }, completion: nil)
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            (toVC as! JKHImageZoomTransitionProtocol).transitionDidFinish?(true, finalImage: fromImageViewCopy.image!)
        }
    }
    
    fileprivate func animate(withTransitionContext context: UIViewControllerContextTransitioning?, animations: @escaping () -> Swift.Void, completion: ((Bool) -> Swift.Void)? = nil) {
        
        UIView.animate(withDuration: self.transitionDuration(using: context), delay: 0, usingSpringWithDamping: self.springDamping, initialSpringVelocity: self.springVelocity, options: .curveLinear, animations: animations, completion: completion)

    }
    
    fileprivate func transformsForZoom(withType type: JKHImageZoomType, toFrame: CGRect, fromFrame: CGRect) -> (from: CGAffineTransform, to: CGAffineTransform) {
        let fromFrameAspectRatio = fromFrame.width / fromFrame.height
        let toFrameCenter = CGPoint(x: toFrame.midX, y: toFrame.midY)
        let fromFrameCenter = CGPoint(x: fromFrame.midX, y: fromFrame.midY)
        
        // From Transform
        let transScaleX = (toFrame.size.height * fromFrameAspectRatio) / fromFrame.size.width
        let transScaleY = (toFrame.size.height) / fromFrame.size.height
        let fromTransPanY = toFrameCenter.y - fromFrameCenter.y
        let fromTransPanX = toFrameCenter.x - fromFrameCenter.x
        
        let fromTransScale = CGAffineTransform(scaleX: transScaleX, y: transScaleY)
        let fromTransPan = CGAffineTransform(translationX: fromTransPanX, y: fromTransPanY)
        let fromTransform = fromTransScale.concatenating(fromTransPan)
        
        // To Transform
        let toTransPanY = fromFrameCenter.y - toFrameCenter.y
        let toTransPanX = fromFrameCenter.x - toFrameCenter.x
    
        let toTransScale = CGAffineTransform(scaleX: 1 / transScaleX, y: 1 / transScaleY)
        let toTransPan = CGAffineTransform(translationX: toTransPanX, y: toTransPanY)
        let toTransform = toTransScale.concatenating(toTransPan)
    
        return (fromTransform, toTransform)
    }
    
    fileprivate func setAnchorPoint(_ anchorPoint:CGPoint, forView view:UIView) {
        var newPoint = CGPoint(x:view.bounds.size.width * anchorPoint.x, y:view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x:view.bounds.size.width * view.layer.anchorPoint.x, y:view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    
    }
    
}
