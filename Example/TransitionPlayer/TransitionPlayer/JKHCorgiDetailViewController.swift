//
//  JKHCorgiDetailViewController.swift
//  TransitionPlayer
//
//  Created by Joon Hong on 8/4/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import UIKit

class JKHCorgiDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!

    var image: UIImage?
    var name = "Unnamed Corgi :("
    var customTransition = false
    
    var isModal: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let im = image {
            imageView.image = im
        }
        
        nameLabel.text = name
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        closeButton.hidden = !isModal
        closeButton.userInteractionEnabled = isModal
        closeButton.layer.borderColor = UIColor.whiteColor().CGColor
        closeButton.layer.cornerRadius = closeButton.frame.width / 2.0
        closeButton.layer.borderWidth = 2.0
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK: - JKHImageZoomTransitionAnimating

extension JKHCorgiDetailViewController: JKHImageZoomTransitionProtocol {
    
    func transitionFromImageView() -> UIImageView {
        imageView.hidden = true
        return imageView
    }

    func transitionToImageView() -> UIImageView {
        imageView.hidden = true
        return imageView
    }
    
    func transitionDidFinish(completed: Bool, finalImage: UIImage) {
        imageView.hidden = !completed
    }
}
