//
//  MapZoneViewController.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-21.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit
import MapKit

class MapZoneViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var countryMissionPair = [String: [String]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.isHidden = true
        
        getCountryMissionPair()
        print(countryMissionPair)
        if Float(getNumberOfReds()) != 0 {
            redSlider.maximumValue = Float(getNumberOfReds())
        } else {
            redSlider.isEnabled = false
        }
        
        if Float(getNumberOfBlues()) != 0 {
            blueSlider.maximumValue = Float(getNumberOfBlues())
        } else {
            blueSlider.isEnabled = false
        }
        
        if Float(getNumberOfGreens()) != 0 {
            greenSlider.maximumValue = Float(getNumberOfGreens())
        } else {
            greenSlider.isEnabled = false
        }
        
        let latitude: CLLocationDegrees = 43.7184038
        let longitude: CLLocationDegrees = -79.5181406
        
        let lanDelta: CLLocationDegrees = 180
        let lonDelta: CLLocationDegrees = 180
        
        map.delegate = self
        
        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        map.setRegion(region, animated: true)
        
//        for index in 0..<CoreDataManager.getArraySize() {
//            let mission = Encrypter.decrypt(CoreDataManager.getAgentMission(at: index))
//            let country = Encrypter.decrypt(CoreDataManager.getAgentCountry(at: index))
//            let lat = CountryLocation.latitude[country]
//            let long = CountryLocation.longitude[country]
//            
//            let annotation = CustomPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
//            if mission == "RED" {
//                annotation.imageName = "redPin"
//            }
//            else if mission == "BLUE" {
//                annotation.imageName = "bluePin"
//            }
//            else {
//                annotation.imageName = "greenPin"
//            }
//            map.addAnnotation(annotation)
//        }
        
        markAnnotation()
        
        // Do any additional setup after loading the view.
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        anView?.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    func getNumberOfReds() -> Int {
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "RED" {
                count += 1
            }
        }
        return count
    }
    
    func getNumberOfBlues() -> Int {
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "BLUE" {
                count += 1
            }
        }
        return count
    }
    
    func getNumberOfGreens() -> Int {
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "GREEN" {
                count += 1
            }
        }
        return count
    }
    
    
    //Red array country assigner
    func getRedCountryArray() -> [Int: String] {
        var array = [Int : String]()
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "RED" {
                count += 1
                let country = CoreDataManager.getAgentCountry(at: index)
                array[count] = Encrypter.decrypt(country)
            }
        }
        return array
    }
    
    func getRedCountry(at index: Float) -> String {
        let arIndex = Int(floor(index))
        let array:[Int: String] = getRedCountryArray()
        return array[arIndex]!
    }
    
    
    //Blue array country assigner
    func getBlueCountryArray() -> [Int: String] {
        var array = [Int : String]()
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "BLUE" {
                count += 1
                let country = CoreDataManager.getAgentCountry(at: index)
                array[count] = Encrypter.decrypt(country)
            }
        }
        return array
    }
    
    func getBlueCountry(at index: Float) -> String {
        let arIndex = Int(floor(index))
        let array:[Int: String] = getBlueCountryArray()
        return array[arIndex]!
    }
    
    
    //Green array country assigner
    func getGreenCountryArray() -> [Int: String] {
        var array = [Int : String]()
        var count = 0
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = CoreDataManager.getAgentMission(at: index)
            if Encrypter.decrypt(mission) == "GREEN" {
                count += 1
                let country = CoreDataManager.getAgentCountry(at: index)
                array[count] = Encrypter.decrypt(country)
            }
        }
        return array
    }
    
    func getGreenCountry(at index: Float) -> String {
        let arIndex = Int(floor(index))
        let array:[Int: String] = getGreenCountryArray()
        return array[arIndex]!
    }
    
    func getCountryMissionPair() {
        
        for index in 0..<CoreDataManager.getArraySize() {
            let country = Encrypter.decrypt(CoreDataManager.getAgentCountry(at: index))
            let mission = Encrypter.decrypt(CoreDataManager.getAgentMission(at: index))
            if countryMissionPair[country] != nil {
                countryMissionPair[country]!.append(mission)
            } else {
                let missionAr:[String] = [mission]
                countryMissionPair[country] = missionAr
            }
        }
    }
    
    func markAnnotation() {
        var countryName = ""
        var imageName = ""
        for (country, missions) in countryMissionPair {
            countryName = country
            var redFlag = 0
            var blueFlag = 0
            var greenFlag = 0
            for mission in missions {
                if mission == "RED" {
                    redFlag = 1
                } else if mission == "BLUE" {
                    blueFlag = 1
                } else {
                    greenFlag = 1
                }
            }
            
            if redFlag == 1 && blueFlag == 1 && greenFlag == 1 {
                imageName = "AllPin"
            } else if redFlag == 1 && blueFlag == 1 {
                imageName = "RedBluePin"
            } else if redFlag == 1 && greenFlag == 1 {
                imageName = "RedGreenPin"
            } else if blueFlag == 1 && greenFlag == 1 {
                imageName = "BlueGreenPin"
            } else if redFlag == 1 {
                imageName = "redPin"
            } else if blueFlag == 1 {
                imageName = "bluePin"
            } else {
                imageName = "greenPin"
            }
            let lat = CountryLocation.latitude[countryName]
            let long = CountryLocation.longitude[countryName]
            let annotation = CustomPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
            annotation.imageName = imageName
            map.addAnnotation(annotation)
        }
        
    }
    
    
    //Slider Functionality
    var initialRedSliderPos = 1
    var initialBlueSliderPos = 1
    var initialGreenSliderPos = 1
    @IBAction func didChangeSlider(_ sender: UISlider) {
        if sender === redSlider {
            if sender.value - Float(initialRedSliderPos) > 0.3 || sender.value - Float(initialRedSliderPos) < -0.3{
                sender.value = round(sender.value)
                initialRedSliderPos = Int(round(sender.value))
            } else {
                sender.value = Float(initialRedSliderPos)
            }
            updateImage(slider: redSlider, index: sender.value)
        } else if sender === blueSlider {
            if sender.value - Float(initialBlueSliderPos) > 0.3 || sender.value - Float(initialBlueSliderPos) < -0.3{
                sender.value = round(sender.value)
                initialBlueSliderPos = Int(round(sender.value))
            } else {
                sender.value = Float(initialBlueSliderPos)
            }
            updateImage(slider: blueSlider, index: sender.value)
        } else {
            if sender.value - Float(initialGreenSliderPos) > 0.3 || sender.value - Float(initialGreenSliderPos) < -0.3{
                sender.value = round(sender.value)
                initialGreenSliderPos = Int(round(sender.value))
            } else {
                sender.value = Float(initialGreenSliderPos)
            }
            updateImage(slider: greenSlider, index: sender.value)
        }
        
    }
    
    //GCD
    var circleAnnotation = CustomPointAnnotation()
    var previousUrlStr = ""
    func updateImage(slider: UISlider, index: Float) {
        
        var currentUrlStr = ""
        var lat = 0.0
        var long = 0.0
        if slider === redSlider {
            currentUrlStr = CountryImages.url[getRedCountry(at: index)]!
            lat = CountryLocation.latitude[getRedCountry(at: index)]!
            long = CountryLocation.longitude[getRedCountry(at: index)]!
        }
        else if slider === blueSlider {
            currentUrlStr = CountryImages.url[getBlueCountry(at: index)]!
            lat = CountryLocation.latitude[getBlueCountry(at: index)]!
            long = CountryLocation.longitude[getBlueCountry(at: index)]!
        }
        else {
            currentUrlStr = CountryImages.url[getGreenCountry(at: index)]!
            lat = CountryLocation.latitude[getGreenCountry(at: index)]!
            long = CountryLocation.longitude[getGreenCountry(at: index)]!
        }
        
        if currentUrlStr != previousUrlStr {
            let span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
            
            let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let region = MKCoordinateRegion(center: coordinates, span: span)
            
            map.setRegion(region, animated: true)
            map.removeAnnotation(circleAnnotation)
            circleAnnotation.coordinate = CLLocationCoordinate2DMake(lat, long)
            circleAnnotation.imageName = "selectedPinCircle"
            map.addAnnotation(circleAnnotation)
            //starts the download indicator
            activity.isHidden = false
            activity.startAnimating()
            redSlider.isEnabled = false
            blueSlider.isEnabled = false
            greenSlider.isEnabled = false
            previousUrlStr = currentUrlStr
            
            //getting the image's url
            let url = URL(string: currentUrlStr)
            
            //creating the background thread
            DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
                let fetch = NSData(contentsOf: url! as URL)
                
                //creating the main thread, that will update the user interface
                DispatchQueue.main.async {
                    if let imageData = fetch {
                        self.image.image = UIImage(data: imageData as Data)
                    }
                    
                    // stops the download indicator
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    
                    //re-enables the sliders
                    if Float(self.getNumberOfReds()) != 0 {
                        self.redSlider.isEnabled = true
                    }
                    if Float(self.getNumberOfBlues()) != 0 {
                        self.blueSlider.isEnabled = true
                    }
                    
                    if Float(self.getNumberOfGreens()) != 0 {
                        self.greenSlider.isEnabled = true
                    }
                    
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
