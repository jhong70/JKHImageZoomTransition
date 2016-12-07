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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        closeButton.isHidden = !isModal
        closeButton.isUserInteractionEnabled = isModal
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.cornerRadius = closeButton.frame.width / 2.0
        closeButton.layer.borderWidth = 2.0
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - JKHImageZoomTransitionAnimating

extension JKHCorgiDetailViewController: JKHImageZoomTransitionProtocol {
    
    func transitionFromImageView() -> UIImageView {
        imageView.isHidden = true
        return imageView
    }

    func transitionToImageView() -> UIImageView {
        imageView.isHidden = true
        return imageView
    }
    
    func transitionDidFinish(_ completed: Bool, finalImage: UIImage) {
        imageView.isHidden = !completed
    }
}
