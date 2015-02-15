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

        if defaults.objectForKey("deals") == nil {
            defaults.setObject(false, forKey: "deals")
        }

        if defaults.objectForKey("sort") == nil {
            defaults.setObject(0, forKey: "sort")
        }

        
        
        
        
//        
//        defaults.setObject("", forKey: "term")
//        defaults.setObject(0, forKey: "radius_filter")
//        defaults.setObject([], forKey: "category_filter")
//        defaults.setObject(false, forKey: "deals")
//        defaults.setObject(0, forKey: "sort")
    }
    
    
    // Could just use normal setters and getters here but I want to keep this separate
    func updateTerm(term: NSString) {
        defaults.setObject(term, forKey: "term")
        defaults.synchronize()
    }
    
    func updateRadius(radius: Int) {
        defaults.setObject(radius, forKey: "radius_filter")
        defaults.synchronize()
    }
    
    func updateDeals(areOn: Bool) {
        defaults.setObject(areOn, forKey: "deals")
        defaults.synchronize()
    }

    func updateSort(sortByValue: Int) {
        defaults.setObject(sortByValue, forKey: "sort")
        defaults.synchronize()
    }
    

//    func getRadius
    
//    func getSort() -> Int {
//        
//    }
    

    
    
    
    
    
    func addCategory(category: NSString) {
        var categories = defaults.objectForKey("category_filter") as NSMutableArray
        categories.addObject(category)
        defaults.setObject(categories, forKey: "category_filter")
        defaults.synchronize()
    }

    func removeCategory(category: NSString) {
        var categories = defaults.objectForKey("category_filter") as NSMutableArray
        categories.removeObject(category)
        defaults.setObject(categories, forKey: "category_filter")
        defaults.synchronize()
    }
    
    
    func processParams() -> NSDictionary {
        let term = defaults.objectForKey("term") as NSString
        let radius = defaults.objectForKey("radius_filter") as Int
        let categories = defaults.objectForKey("category_filter") as [String]
        let deals = defaults.objectForKey("deals") as Bool
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
            paramsDict["deals"] = deals
        }

        if sort != 0 {
            paramsDict["sort"] = sort
        }
        
        
        paramsDict["ll"] = "37.7787151387515,-122.396358157657"
        
        return paramsDict
    }
    
    
    
}