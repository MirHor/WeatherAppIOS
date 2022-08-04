//
//  ViewController.swift
//  WeatherAppIOS
//
//  Created by MacBookAir2014 on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let urlString = "http://api.weatherstack.com/current?access_key=9871b8e5127d49d694d2fe6093df98c5&query=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))"
        
        let url = URL(string: urlString)
        
        var locationName: String?
        var temp: Double?
        var errorHasOccured: Bool = false
        
        let task = URLSession.shared.dataTask(with: url!) {[weak self] (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                as? [String: AnyObject]
                
                if let _ = json?["error"]{
                    errorHasOccured = true
                }
                
        if let json = json{
                    if let location = json["location"] {
                        locationName = location ["name"] as? String
                    }
                    if let current = json["current"]{
                        temp = current["temperature"] as? Double
                    }
            }
                DispatchQueue.main.async {
                    if errorHasOccured{
                        self?.cityLabel.text = "Error. Incorrect name"
                        self?.temperatureLable.isHidden = true
                    }
                    else{
                        self?.cityLabel.text = locationName
                        if let temp = temp {self?.temperatureLable.text = "\(temp)"
                            self?.temperatureLable.isHidden = false
                           
                    }
                    }
                }
                
            }
            catch let jsonError{
                print(jsonError)
            }
           
    }
        task.resume()
}
}

