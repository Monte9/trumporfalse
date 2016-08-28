//
//  RulesViewController.swift
//  Pods
//
//  Created by Monte with Pillow on 8/14/16.
//
//

import UIKit

class RulesViewController: UIViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func dismissViewFromTapGesture(sender: UITapGestureRecognizer) {
        let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
}
