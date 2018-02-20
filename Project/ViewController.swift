//
//  ViewController.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-20.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var agentList: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func unwindToAgentList(_ sender: UIStoryboardSegue) {
        
        if let vc = sender.source as? AddAgentViewController {
            let name = vc.nameText.text!
            let mission = vc.missionText.text!
            let country = vc.countryText.text!
            let date = vc.dateText.text!
            CoreDataManager.addAgent(name: Encrypter.encrypt(name), mission: Encrypter.encrypt(mission), country: Encrypter.encrypt(country), date: Encrypter.encrypt(date))
            agentList.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataManager.getArraySize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = CoreDataManager.getAgentName(at: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            CoreDataManager.deleteAgent(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetailsView", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailsView" {
            if let destination = segue.destination as? DetailsViewController {
                destination.sentIndex = sender as! Int
            }
        }
    }
}

