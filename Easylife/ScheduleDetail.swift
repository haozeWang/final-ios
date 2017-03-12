//
//  ScheduleDetail.swift
//  EasyLife
//
//  Created by 王昊泽 on 17/3/8.
//  Copyright © 2017年 Haoze Wang. All rights reserved.
//

import UIKit

class ScheduleDetail: UIViewController {

    @IBOutlet weak var weather_end: UILabel!
    @IBOutlet weak var weather_begin: UILabel!
    
    @IBOutlet weak var information: UILabel!
    @IBOutlet weak var image_end: UIImageView!
    @IBOutlet weak var image_begin: UIImageView!
    var location_begin = "beijing"
    var location_end = "shanghai"
    var date_begin: Weather!
    var date_end: Weather!
    var url:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "003.jpg")
        self.view.insertSubview(backgroundImage, at: 0)
        loadcurrdate(flag: 1)
        loadcurrdate(flag: 2)
        let date = NSDate()
        loadfurdata(date:date )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadcurrdate(flag : Int){
        
        var url: String!
        if(flag == 1){
            url = "http://api.openweathermap.org/data/2.5/weather?q=\(location_begin)&appid=e5ad7ed727b66d69dc3c323ad8b8fd71"
        }
        if(flag == 2){
            url = "http://api.openweathermap.org/data/2.5/weather?q=\(location_end)&appid=e5ad7ed727b66d69dc3c323ad8b8fd71"
        }
        
        SharedNetwork.SharedInstance.grabSomeData(url){(response) -> Void in
            
            DispatchQueue.main.async
                {
                    if let responsedate = response as? [String:AnyObject]
                        
                    {
                        
                        let weather = responsedate["weather"] as! [AnyObject]
                        
                        let weather_clear = weather[0] as AnyObject
                        let weather_date = weather_clear["description"] as! String
                        let main = responsedate["main"] as! [String:AnyObject]
                        let temperature = main["temp"] as! Int
                        let code = weather_clear["icon"] as! String
                        let sys = responsedate["sys"] as! [String:AnyObject]
                        let country = sys["country"] as! String
                        let city = responsedate["name"] as! String
                        if(flag == 1){
                            self.date_begin = Weather(city: city, country: country, weather: weather_date, temperature: temperature, image: code)
                            self.weather_begin.text = self.date_begin.weather
                            self.image_begin.image = self.getimage(url: "http://openweathermap.org/img/w/\(code).png")
                        }
                        else{
                            self.date_end = Weather(city: city, country: country, weather: weather_date, temperature: temperature, image: code)
                            self.weather_end.text = self.date_end.weather
                            self.image_end.image = self.getimage(url: "http://openweathermap.org/img/w/\(code).png")
                            
                        }
                    }
                    
                    
            }
        }
    }
    
    func loadfurdata(date: NSDate){
        var time = Int(date.timeIntervalSince1970)
        time = time - 21800
        print(time)
        url = "http://api.openweathermap.org/data/2.5/forecast?q=\(location_end)&appid=e5ad7ed727b66d69dc3c323ad8b8fd71"
        print(url)
        SharedNetwork.SharedInstance.grabSomeData(url){(response) -> Void in
            
            DispatchQueue.main.async
                {
                    if let responsedate = response?["list"] as? [AnyObject]
                    {
                        for i in responsedate{
                            if i["dt"] as! Int > time {
                                let wea = i["weather"] as! [AnyObject]
                                let weather_clear = wea[0] as AnyObject
                                let weather_date = weather_clear["description"] as! String
                                if weather_date == "snow"{
                                self.information.text = "During your trip phase，would be snowing. Be careful"
                                return

                                }
                                else if weather_date == "rain" {
                                self.information.text = "During your trip phase，would be raining. Be careful"
                                return
                                }
                                else if weather_date == "thunderstorm"{
                                self.information.text = "During your trip phase，would have thunderstorm. Be careful"
                                    return
                                }
                                else if weather_date == "shower rain" {
                                self.information.text = "During your trip phase，would have shower rain. Be careful"
                                return
                                }
                            }
                            else {
                                self.information.text = "Nice weather. Enjoying your trip"
                            }
                        }
                        self.information.text = "Nice weather. Enjoying your trip"

                    }
            }

        }
    }
    
    
    func getimage(url:String)->UIImage{
        let path = URL(string: url)
        let data = try? Data(contentsOf: path!)
        return UIImage(data: data!)!
    }
    
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
