//
//  RestaurantTableViewCell.swift
//  
//
//  Created by Ryan Newton on 2/11/15.
//
//



//tableview.rowheight = UITableViewAutomaticDimension


import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.preferredMaxLayoutWidth = name.frame.width
        self.thumbnail.layer.cornerRadius = 35
        self.thumbnail.clipsToBounds = true
        // Initialization code
    }

    func fillWithRestaurant(restaurant: Restaurant) {
        name.text = restaurant.name
        distance.text = NSString(format: "%.1f km", restaurant.distance!)//"\(restaurant.distance!) km"
        reviewsCount.text = "\(restaurant.numberOfReviews!) reviews"
        address.text = restaurant.address
        category.text = restaurant.category
        
        let thumbnailUrl = NSURL(string: restaurant.imageUrl!)
        thumbnail.setImageWithURL(thumbnailUrl)
        
        let ratingImageUrl = NSURL(string: restaurant.ratingImageUrl!)
        ratingImage.setImageWithURL(ratingImageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.preferredMaxLayoutWidth = name.frame.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
