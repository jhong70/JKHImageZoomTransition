//
//  JKHCorgiCollectionViewController.swift
//  TransitionPlayer
//
//  Created by Joon Hong on 9/2/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "JKHCorgiCollectionViewCell"

class JKHCorgiCollectionViewController: UICollectionViewController {
    
    var corgiImages = [UIImage]()
    var selectedCorgiCell: JKHCorgiCollectionViewCell?
    var cellPadding: CGFloat = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 1...7 {
            if let image = UIImage(named: "corgi-\(i)") {
                corgiImages.append(image)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! JKHCorgiDetailViewController
        
        vc.image = selectedCorgiCell?.imageView.image
        vc.transitioningDelegate = self
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
 

    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "JKHCorgiCollectionViewHeader", forIndexPath: indexPath)
    }
    

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return corgiImages.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! JKHCorgiCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = corgiImages[indexPath.row]
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let indexPaths = collectionView.indexPathsForSelectedItems(), first = indexPaths.first else {
            return
        }
        
        selectedCorgiCell = collectionView.cellForItemAtIndexPath(first) as? JKHCorgiCollectionViewCell
        performSegueWithIdentifier("CorgiDetailModalSegue", sender: self)
    }
}

extension JKHCorgiCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let screenWidth = UIScreen.mainScreen().bounds.width - cellPadding
        
        return CGSizeMake(screenWidth/2.0, screenWidth/2.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }

}

extension JKHCorgiCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JKHImageZoomAnimationController(type: .In)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JKHImageZoomAnimationController(type: .Out)
    }
}

extension JKHCorgiCollectionViewController: JKHImageZoomTransitionProtocol {
    
    func transitionFromImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.imageView
        
        imageView.hidden = true
        
        return imageView
        
    }
    
    func transitionToImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.imageView
        
        imageView.hidden = true
        
        return imageView
        
    }
    
    func transitionDidFinish(completed: Bool, finalImage: UIImage) {
        
        if completed {
            let imageView = selectedCorgiCell!.imageView
            
            imageView.hidden = false
        }
        
    }
}
