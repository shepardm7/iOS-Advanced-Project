//
//  DetailsViewController.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-25.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var missionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    var sentIndex: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = CoreDataManager.getAgentName(at: sentIndex)
        missionLabel.text = CoreDataManager.getAgentMission(at: sentIndex)
        countryLabel.text = CoreDataManager.getAgentCountry(at: sentIndex)
        dateLabel.text = CoreDataManager.getAgentDate(at: sentIndex)
        // Do any additional setup after loading the view.
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
