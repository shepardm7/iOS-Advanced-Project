//
//  AddAgentViewController.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-20.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit
import MapKit

class AddAgentViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var missionText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var missionColor: UIView!
    
    var missionPicker: UIPickerView = UIPickerView()
    var countryPicker: UIPickerView = UIPickerView()
    var datePickerView: UIDatePicker = UIDatePicker()
    var annotation = MKPointAnnotation()
    let span = MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Agent"
        saveBtn.layer.cornerRadius = 5
        
        dateText.delegate = self
        missionText.delegate = self
        countryText.delegate = self
        
        missionPicker.delegate = self
        countryPicker.delegate = self
        
        missionPicker.tag = 1
        countryPicker.tag = 2
        
        missionColor.layer.borderWidth = 1
        missionColor.layer.borderColor = UIColor.gray.cgColor
        missionColor.layer.cornerRadius = 5
        
        map.isUserInteractionEnabled = false
        map.layer.cornerRadius = 5
        
        missionPicker.backgroundColor = UIColor.white
        countryPicker.backgroundColor = UIColor.white
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.tintColor = UIColor.darkText
        
        toolBar.backgroundColor = UIColor.darkGray
        
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        
        toolBar.setItems([flexSpace,flexSpace,doneButton], animated: true)
        
        dateText.inputAccessoryView = toolBar
        missionText.inputAccessoryView = toolBar
        countryText.inputAccessoryView = toolBar
        
        dateText.inputView = datePickerView
        missionText.inputView = missionPicker
        countryText.inputView = countryPicker
    }
    
    func pickUpDate()
    {
        self.datePickerView.datePickerMode = UIDatePickerMode.date
        self.datePickerView.backgroundColor = UIColor.white
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMY"
        dateText.text = dateFormatter.string(from: sender.date)
    }
    
    
    //Picker setter
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return PickerData.missionData.count
        }
        
        return PickerData.countryData.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return PickerData.missionData[row]
        }
        return PickerData.countryData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            missionText.text = PickerData.missionData[row]
            if PickerData.missionData[row] == "Red" {
                let color = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                missionColor.layer.backgroundColor = color.cgColor
            } else if PickerData.missionData[row] == "Blue" {
                let color = UIColor(red: 0/255.0, green: 150/255.0, blue: 255/255.0, alpha: 1.0)
                missionColor.layer.backgroundColor = color.cgColor
            } else {
                let color = UIColor(red: 0/255.0, green: 255/255.0, blue: 128/255.0, alpha: 1.0)
                missionColor.layer.backgroundColor = color.cgColor
            }
        }
        else {
            countryText.text = PickerData.countryData[row]
            map.removeAnnotation(annotation)
            let lat = CountryLocation.latitude[PickerData.countryData[row].uppercased()]
            let long = CountryLocation.longitude[PickerData.countryData[row].uppercased()]
            let coordinates = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let region = MKCoordinateRegion(center: coordinates, span: span)
            map.setRegion(region, animated: true)
            annotation.coordinate = coordinates
            map.addAnnotation(annotation)
        }
    }
    
    
    func donePressed(sender:UIButton)
    {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField === dateText {
            if textField.text == "" {
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "ddMMY"
                textField.text = formatter.string(from: date)
            }
            self.pickUpDate()
        } else if textField === missionText {
            if textField.text == "" {
                textField.text = PickerData.missionData[0]
                let color = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
                missionColor.layer.backgroundColor = color.cgColor
            }
        } else if textField === countryText {
            if textField.text == "" {
                textField.text = PickerData.countryData[0]
                map.removeAnnotation(annotation)
                let lat = CountryLocation.latitude[PickerData.countryData[0].uppercased()]
                let long = CountryLocation.longitude[PickerData.countryData[0].uppercased()]
                let coordinates = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                let region = MKCoordinateRegion(center: coordinates, span: span)
                map.setRegion(region, animated: true)
                annotation.coordinate = coordinates
                map.addAnnotation(annotation)
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func savePressed(_ sender: UIButton) {
        if nameText.text == "" || missionText.text == "" || countryText.text == "" || dateText.text == "" {
            let alert = UIAlertController(title: "Alert!", message: "All values are required", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "exitToAgentList", sender: nil)
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
