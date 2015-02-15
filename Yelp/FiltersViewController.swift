//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Ryan Newton on 2/12/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit


protocol FiltersViewControllerDelegate {
    func didChangeFilters(filtersViewController: FiltersViewController)
}


class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentedCellDelegate {

    // I can't make this weak?!?
    var delegate: FiltersViewControllerDelegate?
    let paramsManager = ParamsManager()

    let sections = [
        ("Sort By", ["Best Match", "Distance", "Highest Rated"]),
        ("Deals", ["Show only restaurants with deals"]),
        ("Radius", ["3"]),
        ("Categories", ["Breweries", "Czech", "Seafood"]),
        
    ]
    // It seems to make more sense to make an enum instead of doing it this way, but this works for now
    let categoryCodeDict = [
        "Breweries": "breweries",
        "Czech": "czech",
        "Seafood": "seafood"
    ]

    let radiusMeterValues = [0, 200, 1000, 5000]
    let radiusOptions = ["Best match", "200m", "1km", "5km"]
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancelButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "onSearchButton")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
        
        self.tableView.rowHeight = UITableViewAutomaticDimension

        
    }

    
    
    
    
    
    
    
    
    
    
    func onCancelButton() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func onSearchButton() {
        self.delegate?.didChangeFilters(self)
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Switch Cell methods
    func didUpdateValue(cell: SwitchTableViewCell, value: Bool) {
        switch cell.paramType! {
            case "category_filter":
                if value {
                    paramsManager.addCategory(cell.paramValue! as NSString)
                } else {
                    paramsManager.removeCategory(cell.paramValue! as NSString)
                }
            case "deals_filter":
                paramsManager.updateDeals(value)
        default:
            return
        }
    }

    // Segmented Cell methods
    func newSegmentSelected(cell: SegmentedTableViewCell) {
        let selectedIndex = cell.segmentedControl.selectedSegmentIndex
        if cell.paramType! == "radius_filter" {
            paramsManager.updateRadius(radiusMeterValues[selectedIndex])
        }
    }
    
    // Checkbox cell methods. Pretty sure this isn't updating it the right way
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if sections[indexPath.section].0 == "Sort By" {
            // for now index maps to the params you would pass into yelp. Definitely not best practice though
            paramsManager.updateSort(indexPath.row)
        }
        tableView.reloadData()
    }

    // Table view methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        let optionsInSection = sections[indexPath.section].1
        let categoryName = sections[indexPath.section].0
        
        
        switch categoryName {
            case "Radius":
                let cell = tableView.dequeueReusableCellWithIdentifier("SegmentedCell", forIndexPath: indexPath) as SegmentedTableViewCell
                cell.delegate = self
                cell.paramType = "radius_filter"
                cell.fillWithOptions(radiusOptions)
                // This is silly to find it this way, should have created a better object for this setting
                let selectedIndex = find(radiusMeterValues, paramsManager.getRadius()) as Int!
                cell.segmentedControl.selectedSegmentIndex = selectedIndex
                return cell
            case "Sort By":
                let cell = tableView.dequeueReusableCellWithIdentifier("CheckboxCell", forIndexPath: indexPath) as CheckboxTableViewCell
                cell.label.text = optionsInSection[indexPath.row]
                cell.canonicalName = optionsInSection[indexPath.row]
                if indexPath.row == paramsManager.getSort() {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                } else {
                    cell.accessoryType = UITableViewCellAccessoryType.None
                }
                return cell
            case "Deals":
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as SwitchTableViewCell
                cell.delegate = self
                cell.paramType = "deals_filter"
                cell.switchItem.setOn(paramsManager.getDeals(), animated: false)
                cell.filterName.text = optionsInSection[indexPath.row]
                return cell
            case "Categories":
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as SwitchTableViewCell
                cell.delegate = self
                cell.filterName.text = optionsInSection[indexPath.row]
                cell.paramType = "category_filter"
                let paramValue = categoryCodeDict[optionsInSection[indexPath.row]] as String!
                cell.paramValue = paramValue

                if paramsManager.getCategories().containsObject(paramValue) {
                    cell.switchItem.setOn(true, animated: false)
                }
                
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as SwitchTableViewCell
                return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TableViewHeaderView") as UITableViewHeaderFooterView
        header.textLabel.text = sections[section].0
        return header
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
