//
//  JKHCorgiTableViewController.swift
//  TransitionPlayer
//
//  Created by Joon Hong on 8/4/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import UIKit

class JKHCorgiTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var corgiImages = [UIImage]()
    var selectedCorgiCell: JKHCorgiTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for i in 1...7 {
            if let image = UIImage(named: "corgi-\(i)") {
                corgiImages.append(image)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: animated)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! JKHCorgiDetailViewController
        
        vc.image = selectedCorgiCell?.corgiImageView.image
        vc.customTransition = true
    }

}

// MARK: - UITableViewDelegate/Datasource

extension JKHCorgiTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return corgiImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JKHCorgiTableViewCell") as! JKHCorgiTableViewCell
        
        cell.corgiImageView.image = corgiImages[indexPath.row]
        cell.corgiTitleLabel.text = "Corgi number #\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCorgiCell = tableView.cellForRow(at: indexPath) as? JKHCorgiTableViewCell
        performSegue(withIdentifier: "CorgiDetailSegue", sender: self)
    }
    
}

// MARK: - JKHImageZoomTransitionAnimating

extension JKHCorgiTableViewController: JKHImageZoomTransitionProtocol {
    
    func transitionFromImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.corgiImageView
        
        imageView?.isHidden = true
        
        return imageView!
        
    }
    
    func transitionToImageView() -> UIImageView {
        
        let imageView = selectedCorgiCell!.corgiImageView
        
        imageView?.isHidden = true
        
        return imageView!
        
    }
    
    func transitionDidFinish(_ completed: Bool, finalImage: UIImage) {
        
        if completed {
            guard let cell = selectedCorgiCell else {
                return
            }
            
            let imageView = cell.corgiImageView
            
            imageView?.isHidden = false
        }

    }
    
}

