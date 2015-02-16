//
//  RestaurantTableViewCell.swift
//  
//
//  Created by Ryan Newton on 2/11/15.
//
//

import UIKit

protocol RestaurantCellDelegate {
    func cellHighlighted(cell: RestaurantTableViewCell)
    func cellUnhighlighted(cell: RestaurantTableViewCell)
}


class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var descriptionButton: UILabel!

    var delegate: RestaurantCellDelegate?
    var review: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.preferredMaxLayoutWidth = name.frame.width
        self.thumbnail.layer.cornerRadius = 35
        self.thumbnail.clipsToBounds = true

        let frame = self.frame
        descriptionButton.frame = frame
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
        review = restaurant.review
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        name.preferredMaxLayoutWidth = name.frame.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func descriptionButtonPressed(sender: UIButton) {
        self.delegate?.cellHighlighted(self)
    }

    @IBAction func restaurantCellExited(sender: AnyObject) {
        self.delegate?.cellUnhighlighted(self)
    }
}
