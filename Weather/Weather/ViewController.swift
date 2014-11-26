//
//  ViewController.swift
//  Weather
//
//  Created by elf on 11/14/14.
//  Copyright (c) 2014 elf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var usernameLabel : UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var rainfall: UILabel!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var refreshButton: UIButton!
    
    //  forecast.io apiKey
    private let apiKey = "b6d47da2096ad5b40a4ae2c88796fba3"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
        
        // Do any additional setup after loading the view.
    }
    
   
    
    
    
    
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "44.4325,26.1039", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            if (error == nil){
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                
                let currentWeather = Weather(weatherDictionary: weatherDictionary)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentTemperature.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    
                    let formatter = NSDateFormatter()
                    formatter.timeStyle = .ShortStyle
                    self.currentTime.text = formatter.stringFromDate(NSDate())
                    self.humidity.text = "\(Int(currentWeather.humidity * 100))%"
                    self.rainfall.text = "\(Int(currentWeather.precipProbability))%"
                    self.summary.text = "\(currentWeather.summary)"
                    
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            } else {
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data. Connectivity error!", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                networkIssueController.addAction(okButton)
                
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(cancelButton)
                
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshActivityIndicator.stopAnimating()
                    self.refreshActivityIndicator.hidden = true
                    self.refreshButton.hidden = false
                })
            }
        })
        downloadTask.resume()
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logoutTapped(sender : UIButton) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}
