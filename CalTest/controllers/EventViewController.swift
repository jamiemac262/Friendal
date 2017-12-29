//
//  EventViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 02/12/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit
import FacebookCore

class EventViewController: UITableViewController {

    var event:Event? = nil
    var today: DayViewController? = nil
    var isEdit:Bool = false
    let alert: UIAlertController = UIAlertController(title: "Delete", message: "Are you sure? This cannot be undone.", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let delete = UIButton()
        view.isUserInteractionEnabled = true
       // delete.backgroundColor = .red
        //delete.titleLabel?.text = "Delete"
        delete.setTitle("Delete", for: .normal)
        delete.setTitleColor(.red, for: .normal)
        delete.tintColor = .white
        
        delete.addTarget(self, action: #selector(didDelete), for: .touchUpInside)
        
        delete.frame = CGRect(x: 0, y: view.frame.height/2/*-125*/, width: view.frame.width, height: 50)
        view.addSubview(delete)
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = true
        
        tableView.allowsSelection = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didBeginEditing))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "eventItem")
        self.tabBarController?.tabBar.isHidden = true
        
        alert.addAction(UIAlertAction(title: "I'm Sure", style: .default, handler: { (action: UIAlertAction!) in
            AppEventsLogger.log("Deleted Calendar Event")
            let handler = CalendarHandler()
            handler.cancelEvent(event: self.event!.id, forUser: (AccessToken.current?.userId)!, completion: {(response) in
                
                if(response){
                    self.today?.today?.cancelEvent(self.event!.id)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.alert.message = "Something went wrong. Ensure you are connected to the internet and try again."
                    self.present(self.alert, animated: true, completion: nil)
                }
                
            })
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
           
        }))
        
    }

    override func viewWillAppear(_ animated: Bool) {
        title = event?.title
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    @objc func didBeginEditing(){
        
        if(!isEdit){
            self.navigationItem.rightBarButtonItem? = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didBeginEditing))
            isEdit = true
        }else{
            isEdit = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didBeginEditing))
        }
        
        tableView.reloadData()
    }
    
    @objc func didDelete(){
        
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }

    
    
   // override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //MARK: customize cell sizes for map and address(?)
        
   // }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventItem", for: indexPath)
        if(isEdit){
            
        }else{
            switch indexPath.row{
                
            case 0:
                let title = UILabel(frame: CGRect(x: 30, y: 20, width: cell.frame.width, height: cell.frame.height))
                title.font = UIFont.boldSystemFont(ofSize: 30)
                title.text = event?.title
                cell.addSubview(title)
            case 1:
                let location = UILabel(frame: CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height))
                location.text = "Renfrew Town Center"
                cell.addSubview(location)
            case 2://TODO: Create a cell builder class to clean up this code
                if(event?.location != nil){
                    let address = UILabel(frame: CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height))
                    address.text = "Renfrew Town Center"
                    cell.addSubview(address)
                }
            case 3:
                let date = UILabel(frame: CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height))
                date.text = (event?.date)! + daySuffix((event?.date)!) + " "
                date.text = date.text! + dateString((event?.month)!)
                date.text = date.text! + " " + (event?.year)!
                cell.addSubview(date)
            case 4:
                let start = UILabel(frame: CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height))
                start.text = "from " + (event?.start)!
                start.text = start.text! + " to " + (event?.end)!
                cell.addSubview(start)
            case 5:
                let invitees = UILabel(frame: CGRect(x: 30, y: 10, width: cell.frame.width, height: cell.frame.height))
                invitees.text = "Invitees " + (event?.count)!
                
                cell.addSubview(invitees)
            
            default:
                print("defaulting")
            }
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if(indexPath.row == 5){
            return true
        }else{
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        let inviteeView = InviteesTableViewController()
        
        if(event != nil){
           inviteeView.event = event
           navigationController?.pushViewController(inviteeView, animated: true)
        }
    }
    
    func dateString(_ date:String) ->String{
        switch date{
        case "1":
            return "January"
        case "2":
            return "February"
        case "3":
            return "March"
        case "4":
            return "April"
        case "5":
            return "May"
        case "6":
            return "June"
        case "7":
            return "July"
        case "8":
            return "August"
        case "9":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return "ERROR"
        }
    }
    
    func daySuffix(_ day:String) -> String{
        switch day{
        case "1":
            return "st"
        case "2":
            return "nd"
        case "3":
            return "rd"
        default:
            return "th"
        }
    }
}