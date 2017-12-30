//
//  DayViewController.swift
//  CalTest
//
//  Created by Jamie McAllister on 20/11/2017.
//  Copyright © 2017 Jamie McAllister. All rights reserved.
//

import UIKit

class DayViewController: UITableViewController {
    
    var drawEvent:Event? = nil
    
    var today: CalendarDay?{
        didSet{
            navigationItem.title = today?.getFullDate()
        }
    }
    
    let cellID: String = "event"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        tableView.register(TimeTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
       // tableView.isUserInteractionEnabled = false
        //tableView.allowsSelection = false
    }
    func setupView(){
        view.backgroundColor = .white
        //view.addSubview(tableView)
        //tableView.frame = CGRect(x: 0, y: 10, width: view.frame.width, height: view.frame.height)
        
        for (index, event) in (today?.events.enumerated())!{
            
            //TODO: implement overlapping events
            var overlap = 1
            var shift = 0
            let start = makeMinutes(from: event.start!)
            let end = makeMinutes(from: event.end!)
            let id = event.id
            
            for event in (today?.events)!{
                if(event.id == id){
                }else{
                    if(makeMinutes(from: event.start!) >= start && makeMinutes(from: event.start!) <= end){
                        overlap = overlap + 1
                    }else if(makeMinutes(from: event.end!) >= start && makeMinutes(from: event.start!) <= end){//if ends after event starts and starts before the event ends
                        overlap = overlap + 1
                    }
                }
            }
            
            if(index > 0){
                
                let count = index - 1
                
                for i in 0...count{
                    let event = today?.events[i]
                    if(start <= makeMinutes(from: (event?.start!)!) && end >= makeMinutes(from: (event?.start!)!)){
                        shift = shift + 1
                    }else if(start > makeMinutes(from: (event?.start!)!) && start < makeMinutes(from: (event?.end!)!)){
                        shift = shift + 1
                    }
                }
            }
            
            drawEvent(event, overlaps: overlap, shiftBy: shift)
        }
        
        for i in -1...23 {
            drawTime(i)
        }
    }
    
    func drawTime(_ index: Int){
        if(index == -1){
        }else{
            let label = UILabel(frame: CGRect(x: 0, y: (50 * (index+1)) - 25, width: 30, height: 50)  )
            label.text = String(format: "%02d", index)
            tableView.addSubview(label)
        }
    }
    
    func drawEvent(_ event:Event, overlaps:Int, shiftBy:Int){
        
        let start = makeMinutes(from: event.start!)
        let end = makeMinutes(from: event.end!)
        
        let tableLength = 50*25
        let breakdown = CGFloat(tableLength) / CGFloat(1500) //split the table into it's minutes
        
        let startPoint: CGFloat = breakdown * CGFloat(start + 60) // multiply by the start time to push the event down the view
        let duration = CGFloat(end) - CGFloat(start)
        
        let endpoint = breakdown * duration
        
        let eventWidth = (tableView.frame.width - 30) / CGFloat(overlaps)
        
        let shift = eventWidth * CGFloat(shiftBy)
        var frame: CGRect
        if(shiftBy > 0){
            frame = CGRect(x: CGFloat(30 + (5*shiftBy)) + shift, y: startPoint, width: eventWidth, height: endpoint)
            
        }else{
            frame = CGRect(x: CGFloat(30) + shift, y: startPoint, width: eventWidth, height: endpoint)
            
        }
        
        let eventView = EventContainerView(frame: frame)
        eventView.label.text = event.title
        tableView.addSubview(eventView)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TimeTableViewCell
        return cell
    }//end function
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! TimeTableViewCell
        
        tableView.deselectRow(at: indexPath, animated: true)
        let eventView = EventViewController()
        
        if(cell.event != nil){
            eventView.event = cell.event
            eventView.today = self
            navigationController?.pushViewController(eventView, animated: true)
        }
    }
    
    //MARK: Helper functions
    
    func makeMinutes(from: String) -> Int{
        
        let time = from.split(separator: ":")
        
        let htm:Int = Int(String(describing: time[0]))! * 60 //hour to minutes
        
        let minutes = htm + Int(String(describing: time[1]))!
        
        return minutes
        
    }
    
}
