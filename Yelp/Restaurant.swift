//
//  Restaurant.swift
//  Yelp
//
//  Created by Ryan Newton on 2/11/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class Restaurant: NSObject {
    let imageUrl: String?
    let name: String?
    let ratingImageUrl: String?
    let numberOfReviews: Int?
    let address: String?
    let category: String?
    let distance: Float?
    
    init(imageUrl: String, name: String, ratingImageUrl: String, numberOfReviews: Int, address: String, category: String, distance: Float) {
        self.imageUrl = imageUrl
        
        self.name = name
        self.ratingImageUrl = ratingImageUrl
        self.numberOfReviews = numberOfReviews
        self.address = address
        self.category = category
        self.distance = distance
    }

    class func createRestaurantsFromYelpArray(yelpArray: NSArray) -> NSArray {
        var restaurants: NSMutableArray = []
        
        for restaurantDict in yelpArray {

            var imageUrl = "http://s3-media2.fl.yelpcdn.com/assets/srv0/yelp_styleguide/5f69f303f17c/assets/img/default_avatars/business_medium_square.png"
            if let img = restaurantDict["image_url"] as? NSString {
                imageUrl = img
            }

            let name = restaurantDict["name"] as String
            let ratingImageUrl = restaurantDict["rating_img_url"] as String
            let numberOfReviews = restaurantDict["review_count"] as Int

            let location = restaurantDict["location"] as NSDictionary
            let addressArray = location["address"] as NSArray
            
            var neighborhood = "Neighborhood N/A"
            if let neighborhoodArray = location["neighborhoods"] as? NSArray {
                if neighborhoodArray.count > 0 {
                    neighborhood = neighborhoodArray[0] as NSString
                }
            }

            var add = "Address N/A"
            if addressArray.count > 0 {
                add = addressArray[0] as String
            }            
            
            let address = "\(add), \(neighborhood)"
            var categoryString = ""

            if let categories = restaurantDict["categories"] as? NSArray {
                for category in categories {
                    let categoryDisplayName = category[0] as NSString
                    
                    if categoryString == "" {
                        categoryString = "\(categoryDisplayName)"
                    } else {
                        categoryString = "\(categoryString), \(categoryDisplayName)"
                    }
                }
            }
            
            
            let distance = restaurantDict["distance"] as Float
            var distanceInKilometers = distance/1000

            restaurants.addObject(Restaurant(imageUrl: imageUrl, name: name, ratingImageUrl: ratingImageUrl, numberOfReviews: numberOfReviews, address: address, category: categoryString,
                distance: distanceInKilometers))
            
        }
        
        return restaurants as NSArray
    }
}
