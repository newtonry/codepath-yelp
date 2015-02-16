//
//  ParamsManager.swift
//  Yelp
//
//  Created by Ryan Newton on 2/15/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import Foundation

class ParamsManager {
    private var defaults: NSUserDefaults
    
    init() {
        defaults = NSUserDefaults.standardUserDefaults()

        if defaults.objectForKey("term") == nil {
            defaults.setObject("", forKey: "term")
        }

        if defaults.objectForKey("radius_filter") == nil {
            defaults.setObject(0, forKey: "radius_filter")
        }

        if defaults.objectForKey("category_filter") == nil {
            defaults.setObject([], forKey: "category_filter")
        }

        if defaults.objectForKey("deals_filter") == nil {
            defaults.setObject(false, forKey: "deals_filter")
        }

        if defaults.objectForKey("sort") == nil {
            defaults.setObject(0, forKey: "sort")
        }
    }

    func resetDefaults() {
        defaults.setObject("", forKey: "term")
        defaults.setObject(0, forKey: "radius_filter")
        defaults.setObject([], forKey: "category_filter")
        defaults.setObject(false, forKey: "deals_filter")
        defaults.setObject(0, forKey: "sort")
        defaults.synchronize()
    }
    
    func updateTerm(term: NSString) {
        defaults.setObject(term, forKey: "term")
        defaults.synchronize()
    }
    
    func updateRadius(radius: Int) {
        defaults.setObject(radius, forKey: "radius_filter")
        defaults.synchronize()
    }
    
    func updateDeals(areOn: Bool) {
        defaults.setObject(areOn, forKey: "deals_filter")
        defaults.synchronize()
    }

    func updateSort(sortByValue: Int) {
        defaults.setObject(sortByValue, forKey: "sort")
        defaults.synchronize()
    }
    
    func getRadius() -> Int {
        return defaults.objectForKey("radius_filter") as Int
    }

    func getDeals() -> Bool {
        return defaults.objectForKey("deals_filter") as Bool

    }

    func getSort() -> Int {
        return defaults.objectForKey("sort") as Int
    }
    
    func getCategories() -> NSArray {
        return defaults.objectForKey("category_filter") as [String]
    }
    
    func addCategory(category: NSString) {
        var categories = defaults.objectForKey("category_filter") as [String]
        categories.append(category)
        defaults.setObject(categories, forKey: "category_filter")
        defaults.synchronize()
    }

    func removeCategory(category: NSString) {
        var categories = defaults.objectForKey("category_filter") as [String]
        var updatedCategories = categories.filter({ $0 != category })
        defaults.setObject(updatedCategories, forKey: "category_filter")
        defaults.synchronize()
    }
    
    func processParams() -> NSMutableDictionary {
        let term = defaults.objectForKey("term") as NSString
        let radius = defaults.objectForKey("radius_filter") as Int
        let categories = defaults.objectForKey("category_filter") as [String]
        let deals = defaults.objectForKey("deals_filter") as Bool
        let sort = defaults.objectForKey("sort") as Int
        
        var paramsDict: NSMutableDictionary = [:]
        
        if term != "" {
            paramsDict["term"] = term
        }
        
        if radius != 0 {
            paramsDict["radius_filter"] = radius
        }
        
        if categories.count > 0 {
            paramsDict["category_filter"] = ",".join(categories)
        }

        if deals {
            paramsDict["deals_filter"] = deals
        }

        if sort != 0 {
            paramsDict["sort"] = sort
        }

        // Location really should be set later, but this is here just in case
        paramsDict["ll"] = "37.7787151387515,-122.396358157657"
        
        return paramsDict
    }
}