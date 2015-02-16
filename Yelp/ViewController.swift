//
//  ViewController.swift
//  Yelp
//
//  Created by Ryan Newton

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate, CLLocationManagerDelegate {

    var client: YelpClient!
    var restaurants: NSMutableArray?
    var searchBar: UISearchBar?
    let locationManager = CLLocationManager()
    let paramsManager = ParamsManager()
    var offset = 0
    
    
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
        setupNavBar()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
//        tableView.addPullToRefreshWithActionHandler(refreshHandler)
        tableView.addInfiniteScrollingWithActionHandler(refreshHandler)
        
        
        client = YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        searchAndUpdateTableView()
    }
    
    func refreshHandler() {
        searchAndUpdateTableView()
    }
    
    
    func searchAndUpdateTableView() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        var searchParameters = paramsManager.processParams()
        searchParameters["ll"] = getCurrentLocationAsString()
        searchParameters["offset"] = offset
        
        client.searchWithParameters(searchParameters, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let restaurantDictionaryArray = response["businesses"] as NSArray
            
            // This a totally unsustainable way of checking whether we're scrolling or not
            if self.offset != 0 {
                let newRestaurants = Restaurant.createRestaurantsFromYelpArray(restaurantDictionaryArray) as NSArray
                for restaurant in newRestaurants {
                    self.restaurants?.addObject(restaurant)
                    self.tableView.infiniteScrollingView.stopAnimating()
                }
            } else {
                self.restaurants = Restaurant.createRestaurantsFromYelpArray(restaurantDictionaryArray) as? NSMutableArray
            }

            self.offset = self.restaurants!.count
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
            
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                self.paramsManager.resetDefaults() // This is really only for my own debugging purposes
                println(error)
        }
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "onFiltersButton")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    
    // Location Manager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getCurrentLocationAsString() -> String {
        if let location = locationManager.location {
            return "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        } else {
            return "37.7787151387515,-122.396358157657"
        }
    }

    // Search bar
    func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        offset = 0
        paramsManager.updateTerm(searchBar.text)
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

    func didChangeFilters(filtersViewController: FiltersViewController) {
        offset = 0
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

