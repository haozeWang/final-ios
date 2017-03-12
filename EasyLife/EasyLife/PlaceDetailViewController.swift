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
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var photoView1: UIImageView!
    @IBOutlet weak var photoView2: UIImageView!
    @IBOutlet weak var photoView3: UIImageView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var photosView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    @IBOutlet weak var reviewsScrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.image = iconImage
        
        // draw split lines between differnet views
        self.drawSplitLine(view: photosView)
        self.drawSplitLine(view: addressView)
        self.drawSplitLine(view: phoneView)
        
        
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
            
            // load address
            if let address = locationDetail!["formatted_address"] as? String {
                addressLabel.text = address
            }
            
            // load photos
            if let photos = locationDetail!["photos"] as? [AnyObject] {
                if let photo1 = photos[0] as? [String: AnyObject] {
                    loadPhoto(photoInfo: photo1, photoView: photoView1)
                }
                if let photo2 = photos[1] as? [String: AnyObject] {
                    loadPhoto(photoInfo: photo2, photoView: photoView2)
                }
                if let photo3 = photos[2] as? [String: AnyObject] {
                    loadPhoto(photoInfo: photo3, photoView: photoView3)
                }
            }
            
            // load phone number
            if let phoneNumber = locationDetail!["international_phone_number"] as? String {
                phoneLabel.text = phoneNumber
            }
            
            // load reviews
            if let reviews = locationDetail!["reviews"] as? [AnyObject] {
                let n = reviews.count
                let frameWidth = reviewsScrollView.frame.size.width
                let frameHeight = reviewsScrollView.frame.size.height
                reviewsScrollView.contentSize = CGSize(width: frameWidth,
                                                       height: frameHeight * CGFloat(n))
                for i in 0..<n {
                    guard let review = reviews[i] as? [String: AnyObject] else {    continue}
                    guard let author = review["author_name"] as? String else { continue}
                    guard let timeInt = review["time"] as? Int else {   continue}
                    let time = Date(timeIntervalSince1970: TimeInterval(timeInt))
                    
                    let authorLabel = UILabel(frame: CGRect(x: 10,
                                                            y: CGFloat(5) + frameHeight * CGFloat(i),
                                                            width: 200, height: 30))
                    let timeLabel = UILabel(frame: CGRect(x: 10,
                                                          y: CGFloat(35) + frameHeight * CGFloat(i),
                                                          width: 200, height: 20))
                    
                    authorLabel.text = author
                    timeLabel.text = "\(time)"
                    timeLabel.font = UIFont.systemFont(ofSize: 10)
                    
                    reviewsScrollView.addSubview(authorLabel)
                    reviewsScrollView.addSubview(timeLabel)
                }
            }
            
        }
        
    }

    
    // load photos
    func loadPhoto(photoInfo: [String: AnyObject], photoView: UIImageView) {
        if let photoRef = photoInfo["photo_reference"] as? String {
            let photoUrl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=125&photoreference=\(photoRef)&key=AIzaSyBIMD_Nulnv7yw4OaKa-rEAqvI3I_hAv4E"
            SharedNetworking.networkInstance.downloadImage(urlString: photoUrl){
                (imageData, success) -> Void in
                if success {
                    DispatchQueue.main.async {
                        let photoImage = UIImage(data: imageData as Data)
                        photoView.image = photoImage
                        photoView.contentMode = .scaleToFill
                        photoView.layer.borderWidth = 2.5
                        photoView.layer.borderColor = UIColor.lightGray.cgColor
                    }
                }
            }
        }
    }
    
    // draw split line at the top of the view
    func drawSplitLine(view: UIView) {
        let splitLine = UIView(frame: CGRect(x: 5, y: 0, width: 365, height: 1))
        splitLine.backgroundColor = UIColor.lightGray
        view.addSubview(splitLine)
    }
    
}
