//
//  ViewController.swift
//  AutoLayout
//
//  Created by AmenophisIII on 7/25/15.
//  Copyright (c) 2015 AmenophisIII. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    var loggedInUser : User? { didSet { updateUI() } }
    var secure : Bool = false { didSet { updateUI() } }
    
    // update the UI after a viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUser = User (name: "Madison Bumgarner", company: "World Champion San Francisco Giants", login: "madbum", password: "foo")
        updateUI()
    }
    
    
    
    private func updateUI(){
        passwordLabel.text = secure ? "Secured Password" : "Password"
        passwordField.secureTextEntry = secure
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        // imageView.image = loggedInUser?.image // note user cannot have a image and it isn't defined into it. but we can have extension to use the image... (creating this in the controller will leave the model untouched)
        image = loggedInUser?.image
        // WHere we call the newly defined image property
       
 
    }
    
    
    // the buttons triggering changes:
    @IBAction func toggleSecurity() { secure = !secure }
    @IBAction func login() { loggedInUser = User.login(usernameField.text ?? "", password: passwordField.text ?? "") }
    
    
    
    // the following code calculates the aspect ratio of the image and maintains it!
    var aspectRatioConstraint : NSLayoutConstraint? {
        didSet {
            if let newConstraint = aspectRatioConstraint /*in other words if not nil */
            {
                view.addConstraint(newConstraint)
            }
        }
        willSet {
            if let existingConstraint = aspectRatioConstraint
            {
                view.removeConstraint(existingConstraint)
            }
        }
    }
    
    var image : UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint  = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio, /* there is no method for AR, so we add it as an extension */
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }
    
    
    
    
    
    
}


// this enables the model class "User.swift" to remain pure, while being extended in the controller
extension User
{
    var image : UIImage? {
        if let image = UIImage (named: login) {
            return image
        } else {
            return UIImage (named: "unknown_user")
        }
    }
}

// oh look! how nicely it works!
extension UIImage
{
    var aspectRatio : CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}

