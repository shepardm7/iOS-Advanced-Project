//
//  CoreDataManager.swift
//  Project
//
//  Created by Sateek Roy on 2017-07-20.
//  Copyright © 2017 SateekLambton. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private static let context = appDelegate.persistentContainer.viewContext
    
    private static let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Agents")
    
    private static func setData() -> [NSManagedObject] {
        var d = [NSManagedObject]()
        request.returnsObjectsAsFaults = false
        
        do {
            d = try context.fetch(request) as! [NSManagedObject]
        } catch {
            print("Couldn't fetch request")
        }
        return d
    }
    
    private static var data: [NSManagedObject] = setData()
    
    public static func getArraySize() -> Int {
        return data.count
    }
    
    //Adding a new Agent
    public static func addAgent(name: String, mission: String, country: String, date: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Agents", in: context)!
        
        let agent = NSManagedObject(entity: entity, insertInto: context)
        
        agent.setValue(name, forKey: "name")
        agent.setValue(mission, forKey: "mission")
        agent.setValue(country, forKey: "country")
        agent.setValue(date, forKey: "date")
        do {
            try context.save()
            data.append(agent)
        } catch let error as NSError {
            print("could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Deleting an Agent
    public static func deleteAgent(at index: Int) {
        context.delete(data[index])
        do {
            try context.save()
        }
        catch {
            print("Failed to delete")
        }
        data.remove(at: index)
    }
    
    //Getting the name of an Agent
    public static func getAgentName(at index: Int) -> String {
        return data[index].value(forKey: "name") as! String
    }
    
    //Getting the mission of an Agent
    public static func getAgentMission(at index: Int) -> String {
        return data[index].value(forKey: "mission") as! String
    }
    
    //Getting the country of an Agent
    public static func getAgentCountry(at index: Int) -> String {
        return data[index].value(forKey: "country") as! String
    }
    
    //Getting the date of an Agent
    public static func getAgentDate(at index: Int) -> String {
        return data[index].value(forKey: "date") as! String
    }
    
}
