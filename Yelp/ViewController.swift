//
//  ViewController.swift
//  Yelp
//
//  Created by Ryan Newton

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    var client: YelpClient!
    var restaurants: NSArray?
    var searchBar: UISearchBar?
//    var searchParameters: NSMutableDictionary = ["term":"", "ll": "37.7787151387515,-122.396358157657"]
    let locationManager = CLLocationManager()
    let paramsManager = ParamsManager()
    
    let yelpConsumerKey = "4XsQYHhLRG6ilyEMopHl2w"
    let yelpConsumerSecret = "pWCAyX_NSUM9NDXO_a7C70f64Iw"
    let yelpToken = "s71uVHG94CpkEDTNEC3py71lZbkB5qA_"
    let yelpTokenSecret = "PP_96B9-MdQ-L85jXOvWwD3ySNw"
    
    
    @IBOutlet weak var tableView: UITableView!

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupLocationManager()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "onFiltersButton")
        

        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        searchAndUpdateTableView()
        
    }
    
    func searchAndUpdateTableView() {
        let searchParameters = paramsManager.processParams()
        
        client.searchWithParameters(searchParameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let restaurantDictionaryArray = response["businesses"] as NSArray
            self.restaurants = Restaurant.createRestaurantsFromYelpArray(restaurantDictionaryArray) as NSArray
            self.tableView.reloadData()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    // Location Manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        println(locationManager.location)
        
        // TODO need to add this stuff to the plist!
    
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    

    // Search bar
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchParameters["term"] = searchBar.text
        
        paramsManager.updateTerm(searchBar.text)
        paramsManager.processParams()
        
        
        self.navigationController?.view.endEditing(true)
        searchAndUpdateTableView()
        
        println("Searching for \(searchBar.text)")
    }
    
    
    // Filter view controller handling
    func onFiltersButton() {
        let filtersViewController = self.storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController") as FiltersViewController
        filtersViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: filtersViewController)
        presentViewController(navigationController, animated: true, completion: nil)
    }


    func didChangeFilters(filtersViewController: FiltersViewController, filters: NSDictionary) {
//        for (paramName, paramValue) in filters {
////            searchParameters[paramName as String] = paramValue as String
//        }
        
        
        
        
        searchAndUpdateTableView()
    }
    
    
    
    // Table view handlers
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell") as RestaurantTableViewCell
        let restaurant = restaurants![indexPath.row] as Restaurant
        cell.fillWithRestaurant(restaurant)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = restaurants {
            return array.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell") as RestaurantTableViewCell
        let restaurant = restaurants![indexPath.row] as Restaurant
        cell.fillWithRestaurant(restaurant)
        
        cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height + 1
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

