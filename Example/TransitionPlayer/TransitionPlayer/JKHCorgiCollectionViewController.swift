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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! JKHCorgiDetailViewController
        
        vc.image = selectedCorgiCell?.imageView.image
        vc.transitioningDelegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
 

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "JKHCorgiCollectionViewHeader", for: indexPath)
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return corgiImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! JKHCorgiCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = corgiImages[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let indexPaths = collectionView.indexPathsForSelectedItems, let first = indexPaths.first else {
            return
        }
        
        selectedCorgiCell = collectionView.cellForItem(at: first) as? JKHCorgiCollectionViewCell
        performSegue(withIdentifier: "CorgiDetailModalSegue", sender: self)
    }
}

extension JKHCorgiCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = UIScreen.main.bounds.width - cellPadding
        
        return CGSize(width: screenWidth/2.0, height: screenWidth/2.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

}

extension JKHCorgiCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JKHImageZoomAnimationController(type: .inward)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JKHImageZoomAnimationController(type: .outward)
    }
}

extension JKHCorgiCollectionViewController: JKHImageZoomTransitionProtocol {
    
    func transitionFromImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.imageView
        
        imageView?.isHidden = true
        
        return imageView!
        
    }
    
    func transitionToImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.imageView
        
        imageView?.isHidden = true
        
        return imageView!
        
    }
    
    func transitionDidFinish(_ completed: Bool, finalImage: UIImage) {
        
        if completed {
            let imageView = selectedCorgiCell!.imageView
            
            imageView?.isHidden = false
        }
        
    }
}
