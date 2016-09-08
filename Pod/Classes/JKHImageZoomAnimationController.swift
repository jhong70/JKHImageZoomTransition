//
//  JKHImageZoomAnimationController.swift
//
//  Created by Joon Hong on 8/4/16.
//  Copyright © 2016 Joon Ki Hong. All rights reserved.
//

import Foundation
import UIKit

@objc protocol JKHImageZoomTransitionProtocol {
    optional func transitionFromImageView() -> UIImageView
    optional func transitionToImageView() -> UIImageView
    optional func transitionDidFinish(completed: Bool, finalImage: UIImage)
}

class JKHImageZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum JKHImageZoomType {
        case In
        case Out
    }
    
    var backgroundColor: UIColor
    var viewContentMode: UIViewContentMode
    var duration: NSTimeInterval
    var springVelocity: CGFloat
    var springDamping: CGFloat
    var type: JKHImageZoomType
    
    init(type: JKHImageZoomType, backgroundColor: UIColor = UIColor.whiteColor(), viewContentMode: UIViewContentMode = .ScaleAspectFill, duration: NSTimeInterval = 0.5, springVelocity: CGFloat = 1.5, springDamping: CGFloat = 1.0) {
        self.backgroundColor = backgroundColor
        self.viewContentMode = viewContentMode
        self.duration = duration
        self.springVelocity = springVelocity
        self.springDamping = springDamping
        self.type = type
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let containerView = transitionContext.containerView() else {
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
            toVC = (toVC as! UITabBarController).selectedViewController!
        }
        
        let fromVCSnapshot = fromView.snapshotViewAfterScreenUpdates(false)
        
        containerView.backgroundColor = backgroundColor
        containerView.addSubview(toView)
        containerView.addSubview(fromVCSnapshot)
        
        fromView.hidden = true
        toView.setNeedsLayout()
        toView.layoutIfNeeded()
        
        let fromImageView = (fromVC as! JKHImageZoomTransitionProtocol).transitionFromImageView!()
        let fromImageViewCopy = UIImageView(image: fromImageView.image)
        let toImageView = (toVC as! JKHImageZoomTransitionProtocol).transitionToImageView!()
        let toImageViewFrame = containerView.convertRect(toImageView.frame, fromView: toImageView.superview)
        
        fromImageViewCopy.contentMode = viewContentMode
        fromImageViewCopy.clipsToBounds = true
        fromImageViewCopy.frame = containerView.convertRect(fromImageView.frame, fromView: fromImageView.superview)
        
        containerView.addSubview(fromImageViewCopy)
        
        fromVCSnapshot.layer.anchorPoint = CGPointMake(fromImageViewCopy.center.x/containerView.frame.size.width, fromImageViewCopy.center.y/containerView.frame.size.height)
        fromVCSnapshot.layer.position = fromImageViewCopy.center

//        toView.layer.anchorPoint = CGPointMake(toImageView.center.x/containerView.frame.size.width, toImageView.center.y/containerView.frame.size.height)
//        toView.layer.position = toImageView.center
    
        let transforms = transformsForZoom(type, toFrame: toImageViewFrame, fromFrame: fromImageViewCopy.frame)
        
        toView.transform = transforms.to

        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: springDamping, initialSpringVelocity: springVelocity, options: .CurveLinear, animations: {
            fromImageViewCopy.frame = toImageViewFrame
            fromVCSnapshot.alpha = 0
            fromVCSnapshot.transform = transforms.from
            toView.transform = CGAffineTransformIdentity
        }) { (completed) in
            if completed {
                toView.layer.position = toView.center
                fromView.hidden = false
                fromImageViewCopy.removeFromSuperview()
                fromVCSnapshot.removeFromSuperview()
                (toVC as! JKHImageZoomTransitionProtocol).transitionDidFinish?(true, finalImage: fromImageViewCopy.image!)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            } else {
                (toVC as! JKHImageZoomTransitionProtocol).transitionDidFinish?(false, finalImage: fromImageViewCopy.image!)
            }
        }
    }
    
    private func transformsForZoom(type: JKHImageZoomType, toFrame: CGRect, fromFrame: CGRect) -> (from: CGAffineTransform, to: CGAffineTransform) {
        let fromFrameAspectRatio = CGRectGetWidth(fromFrame) / CGRectGetHeight(fromFrame)
        let toFrameCenter = CGPointMake(CGRectGetMidX(toFrame), CGRectGetMidY(toFrame))
        let fromFrameCenter = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMidY(fromFrame))
        
        // From Transform
        let transScaleX = (toFrame.size.height * fromFrameAspectRatio) / fromFrame.size.width
        let transScaleY = (toFrame.size.height) / fromFrame.size.height
        let fromTransPanY = (toFrameCenter.y - fromFrameCenter.y) / transScaleY
        let fromTransPanX = (toFrameCenter.x - fromFrameCenter.x) / transScaleX
        
        let fromTransScale = CGAffineTransformMakeScale(transScaleX, transScaleY)
        let fromTransPan = CGAffineTransformMakeTranslation(fromTransPanX, fromTransPanY)
        let fromTransform = CGAffineTransformConcat(fromTransPan, fromTransScale)
        
        // To Transform
        let toTransPanY = (fromFrameCenter.y - toFrameCenter.y) * (type == .In ? transScaleY : 1)
        let toTransPanX = (fromFrameCenter.x - toFrameCenter.x) * (type == .In ? transScaleX : 1)
    
        let toTransScale = CGAffineTransformMakeScale(1 / transScaleX, 1 / transScaleY)
        let toTransPan = CGAffineTransformMakeTranslation(toTransPanX, toTransPanY)
        let toTransform = CGAffineTransformConcat(toTransPan, toTransScale)
        
        return (fromTransform, toTransform)
    }
    
}