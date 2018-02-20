//
//  MissionUpdateViewController.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-22.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class MissionUpdateViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var redDistLabel: UILabel!
    @IBOutlet weak var blueDistLabel: UILabel!
    @IBOutlet weak var greenDistLabel: UILabel!
    @IBOutlet weak var redCam: UIImageView!
    @IBOutlet weak var blueCam: UIImageView!
    @IBOutlet weak var greenCam: UIImageView!
    @IBOutlet weak var redEmail: UIImageView!
    @IBOutlet weak var blueEmail: UIImageView!
    @IBOutlet weak var greenEmail: UIImageView!
    
    var countryMissionPair = [String: [String]]()
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    var userLat: CLLocationDegrees = 0
    var userLong: CLLocationDegrees = 0
    
    
    var locationManager : CLLocationManager!
    
    var redCountries = [String]()
    var blueCountries = [String]()
    var greenCountries = [String]()
    
    let span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
    var userAnnotation = CustomPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        map.setRegion(region, animated: true)
        
        setRedCountries()
        setBlueCountrie()
        setGreenCountrie()
        getCountryMissionPair()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineCurrentLocation()
        markAnnotations()
        
    }
    
    @IBAction func moveToUserLocation(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(userLat, userLong), span: span)
        map.setRegion(region, animated: true)
    }
    
    func setRedCountries(){
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = Encrypter.decrypt(CoreDataManager.getAgentMission(at: index))
            if mission == "RED" {
                let country = Encrypter.decrypt(CoreDataManager.getAgentCountry(at: index))
                redCountries.append(country)
            }
        }
    }
    
    func setBlueCountrie() {
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = Encrypter.decrypt(CoreDataManager.getAgentMission(at: index))
            if mission == "BLUE" {
                let country = Encrypter.decrypt(CoreDataManager.getAgentCountry(at: index))
                blueCountries.append(country)
            }
        }
    }
    
    func setGreenCountrie() {
        for index in 0..<CoreDataManager.getArraySize() {
            let mission = Encrypter.decrypt(CoreDataManager.getAgentMission(at: index))
            if mission == "GREEN" {
                let country = Encrypter.decrypt(CoreDataManager.getAgentCountry(at: index))
                greenCountries.append(country)
            }
        }
    }
    
    func getRedMinimumDistance() {
        var distArray = [Double]()
        for country in redCountries {
            let lat = CountryLocation.latitude[country]
            let long = CountryLocation.longitude[country]
            let destCoordinate = CLLocation(latitude: lat!, longitude: long!)
            let userCoordinate = CLLocation(latitude: userLat, longitude: userLong)
            distArray.append(destCoordinate.distance(from: userCoordinate))
        }
        
        if distArray.count != 0 {
            var min = distArray[0]
            for dist in distArray {
                if dist < min {
                    min = dist
                }
            }
            min = min/1000
            redDistLabel.text = "Nearest: " + String(format: "%.2f", min) + " km away"
        } else {
            redDistLabel.text = "Nearest: NA"
        }
    }
    
    func getBlueMinimumDistance() {
        var distArray = [Double]()
        for country in blueCountries {
            let lat = CountryLocation.latitude[country]
            let long = CountryLocation.longitude[country]
            let destCoordinate = CLLocation(latitude: lat!, longitude: long!)
            let userCoordinate = CLLocation(latitude: userLat, longitude: userLong)
            distArray.append(destCoordinate.distance(from: userCoordinate))
        }
        
        if distArray.count != 0 {
            var min = distArray[0]
            for dist in distArray {
                if dist < min {
                    min = dist
                }
            }
            min = min/1000
            blueDistLabel.text = "Nearest: " + String(format: "%.2f", min) + " km away"
        } else {
            blueDistLabel.text = "Nearest: NA"
        }
    }
    
    func getGreenMinimumDistance() {
        var distArray = [Double]()
        for country in greenCountries {
            let lat = CountryLocation.latitude[country]
            let long = CountryLocation.longitude[country]
            let destCoordinate = CLLocation(latitude: lat!, longitude: long!)
            let userCoordinate = CLLocation(latitude: userLat, longitude: userLong)
            distArray.append(destCoordinate.distance(from: userCoordinate))
        }
        
        if distArray.count != 0 {
            var min = distArray[0]
            for dist in distArray {
                if dist < min {
                    min = dist
                }
            }
            min = min/1000
            greenDistLabel.text = "Nearest: " + String(format: "%.2f", min) + " km away"
        } else {
            greenDistLabel.text = "Nearest: NA"
        }
    }
    
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation: CLLocation = locations[locations.count - 1] as CLLocation
        
        userLat = userlocation.coordinate.latitude
        userLong = userlocation.coordinate.longitude
        markUserLocation(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
        manager.stopUpdatingLocation()
        getRedMinimumDistance()
        getBlueMinimumDistance()
        getGreenMinimumDistance()
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
    
    func markAnnotations() {
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
    
    func markUserLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        map.removeAnnotation(userAnnotation)
        userAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        userAnnotation.imageName = "userPin"
        map.addAnnotation(userAnnotation)
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
    
    @IBAction func getRedImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Select your image source", message: nil, preferredStyle: .alert)
        
        alert.addAction((UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in self.captureImage(self.redCam)})))
        
        alert.addAction((UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) in self.accessGallery(self.redCam)})))
        
        alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func getBlueImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Select your image source", message: nil, preferredStyle: .alert)
        
        alert.addAction((UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in self.captureImage(self.blueCam)})))
        
        alert.addAction((UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) in self.accessGallery(self.blueCam)})))
        
        alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func getGreenImage(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Select your image source", message: nil, preferredStyle: .alert)
        
        alert.addAction((UIAlertAction(title: "Camera", style: .default, handler: {(alert: UIAlertAction!) in self.captureImage(self.greenCam)})))
        
        alert.addAction((UIAlertAction(title: "Gallery", style: .default, handler: {(alert: UIAlertAction!) in self.accessGallery(self.greenCam)})))
        
        alert.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil)))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    var selectedImageView = UIImageView()
    func captureImage(_ sender: UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning!", message: "No camera found!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        selectedImageView = sender
    }
    
    func accessGallery(_ sender: UIImageView) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        selectedImageView = sender
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageView.image = selectedImage
            dismiss(animated: true, completion: nil)
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
    
    var recipient = ""
    var subject = ""
    var message = ""
    @IBAction func redEmailAction(_ sender: UIButton) {
        recipient = "redagents@xlambton.com"
        subject = "Mission Update"
        message = "Red update"
        selectedImageView = redCam
        initiateEmailController()
    }
    
    @IBAction func blueEmailAction(_ sender: UIButton) {
        recipient = "blueagent@xlambton.com"
        subject = "Mission Update"
        message = "Blue update"
        selectedImageView = blueCam
        initiateEmailController()
    }
    
    @IBAction func greenEmailAction(_ sender: UIButton) {
        recipient = "greenagent@xlambton.com"
        subject = "Mission Update"
        message = "Green update"
        selectedImageView = greenCam
        initiateEmailController()
    }
    
    func initiateEmailController() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients([recipient])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(message, isHTML: false)
        
        if selectedImageView.image != #imageLiteral(resourceName: "camIcon") {
            if let image = selectedImageView.image {
                let data = UIImageJPEGRepresentation(image, 1.0)
                mailComposerVC.addAttachmentData(data!, mimeType: "image/jpg", fileName: "image")
            }
        }
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Could not send E-mail!", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetRedImageGesture(_ sender: UILongPressGestureRecognizer) {
        if redCam.image != #imageLiteral(resourceName: "camIcon"){
            let alert = UIAlertController(title: "Remove image?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.redCam.image = #imageLiteral(resourceName: "camIcon")}))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func resetBlueImageGesture(_ sender: UILongPressGestureRecognizer) {
        if blueCam.image != #imageLiteral(resourceName: "camIcon") {
            let alert = UIAlertController(title: "Remove image?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.blueCam.image = #imageLiteral(resourceName: "camIcon")}))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func resetGreenImageGesture(_ sender: UILongPressGestureRecognizer) {
        if greenCam.image != #imageLiteral(resourceName: "camIcon") {
            let alert = UIAlertController(title: "Remove image?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(alert: UIAlertAction!) in self.greenCam.image = #imageLiteral(resourceName: "camIcon")}))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
