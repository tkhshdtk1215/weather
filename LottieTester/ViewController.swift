//
//  ViewController.swift
//  LottieTester
//
//  Created by hidetaka on 2019/10/23.
//  Copyright © 2019 hidetaka. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,CLLocationManagerDelegate {

    
    var myLocationManager:CLLocationManager!
    var myLatitude: CLLocationDegrees!
    var myLongitude: CLLocationDegrees!

    @IBOutlet var myLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humiLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    
    @IBOutlet var anubisView: UIView!
    @IBOutlet var weatherImage: UIImageView!
    
       
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let animationView = AnimationView(name: "1625-anubis")
        animationView.frame = CGRect(x: 0, y: 0, width:self.anubisView.frame.width, height:self.anubisView.frame.height)
        animationView.play()
        animationView.loopMode = LottieLoopMode.loop
        animationView.backgroundBehavior = .pauseAndRestore
        anubisView.addSubview(animationView)
        
        self.myLabel.text = "今日の\n天気は..."
        
        
        self.myLocation()
        
        
    }

    func myLocation() {
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status)");
        // まだ認証が得られていない場合は、認証ダイアログを表示
        // (このAppの使用中のみ許可の設定)
        if(status == .notDetermined) {
           self.myLocationManager.requestWhenInUseAuthorization()
        }
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        myLocationManager.startUpdatingLocation()
        
    }
    
   
    

    func getweather(){
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather?lat=\(String(myLatitude))&lon=\(String(myLongitude))&appid=c41e699e43ec1b7695113739b764ee00").validate().responseJSON { response in
            if let jsonObject = response.result.value {
                let json = JSON(jsonObject)
                let weather = json["weather"][0]["main"].stringValue
                let tempreture = json["main"]["temp"].doubleValue
                let humidity = json["main"]["humidity"].stringValue
                let wind = json["wind"]["speed"].doubleValue
                print(weather)
                print(tempreture)
                print(humidity)
                print(wind)
                self.tempLabel.text = "温度:\(round((tempreture-273)*10)/10)度"
                self.humiLabel.text = "湿度:\(humidity)%"
                self.windLabel.text = "風速:\(round(wind*10)/10)m/s"
                switch weather {
                case "Clear":
                    self.weatherImage.image = UIImage(named: "clear")
                case "Clouds":
                    self.weatherImage.image = UIImage(named: "clouds")
                case "Rain":
                    self.weatherImage.image = UIImage(named: "rain")
                case "Thunderstorm":
                    self.weatherImage.image = UIImage(named: "thunderstorm")
                case "Drizzle":
                    self.weatherImage.image = UIImage(named: "drizzle")
                case "Snow":
                    self.weatherImage.image = UIImage(named: "snow")
                default:
                    self.weatherImage.image = UIImage(named: "clouds")
                }
                
            }
        }
    }
    
    
     //認証に変化があった際に呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        print("didChangeAuthorizationStatus");

        // 認証のステータスをログで表示.
        var statusStr: String = "";
        switch (status) {
        case .notDetermined:
            statusStr = "未認証の状態"
        case .restricted:
            statusStr = "制限された状態"
        case .denied:
            statusStr = "許可しない"
        case .authorizedAlways:
            statusStr = "常に使用を許可"
        case .authorizedWhenInUse:
            statusStr = "このAppの使用中のみ許可"
        default:
            break
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }

    
     //位置情報取得に成功したときに呼び出されるデリゲート.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 緯度・経度の表示.
        self.myLatitude = manager.location!.coordinate.latitude
        self.myLongitude = manager.location!.coordinate.longitude
        self.getweather()
    }
    
     //位置情報取得に失敗した時に呼び出されるデリゲート.
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print("error")
    }
    
    
}

