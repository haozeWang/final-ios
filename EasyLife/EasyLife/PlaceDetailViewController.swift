//
//  PlaceDetailViewController.swift
//  EasyLife
//
//  Created by Meng Wang on 3/11/17.
//  Copyright © 2017 Haoze Wang. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    var locationDetail: [String: AnyObject]? = nil
    var iconImage: UIImage? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = iconImage
        
        print("!!!!!!!!!")
        //print(locationDetail as Any)
        
        if locationDetail != nil {
            if let name = locationDetail!["name"] as? String {
                nameLabel.text = name
            }
            
            // set rating
            if let rating = locationDetail!["rating"] {
                print(rating)
                ratingLabel.text = "Rating: \(rating)"
                
                if let ratingDouble = rating as? Double {
                    // first star
                    if ratingDouble >= 0.25 && ratingDouble < 0.75 {
                        star1.image = UIImage(named: "star half")
                    } else if ratingDouble >= 0.75 {
                        print(1)
                        star1.image = UIImage(named: "star")
                    }
                    
                    // second star
                    if ratingDouble >= 1.25 && ratingDouble < 1.75 {
                        star2.image = UIImage(named: "star half")
                    } else if ratingDouble >= 1.75 {
                        star2.image = UIImage(named: "star")
                    }
                    
                    // third star
                    if ratingDouble >= 2.25 && ratingDouble < 2.75 {
                        star3.image = UIImage(named: "star half")
                    } else if ratingDouble >= 2.75 {
                        star3.image = UIImage(named: "star")
                    }
                    
                    // fourth star
                    if ratingDouble >= 3.25 && ratingDouble < 3.75 {
                        star4.image = UIImage(named: "star half")
                    } else if ratingDouble >= 3.75 {
                        star4.image = UIImage(named: "star")
                    }
                    
                    // fifth star
                    if ratingDouble >= 4.25 && ratingDouble < 4.75 {
                        star5.image = UIImage(named: "star half")
                    } else if ratingDouble >= 4.75 {
                        star5.image = UIImage(named: "star")
                    }
                    
                }
            }
            

            
            
        }
        
    }

    
    
    
    
}
