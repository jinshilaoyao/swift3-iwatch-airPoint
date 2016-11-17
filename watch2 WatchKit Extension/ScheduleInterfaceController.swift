//
//  ScheduleInterfaceController.swift
//  watch2
//
//  Created by yesway on 2016/11/16.
//  Copyright © 2016年 joker. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {

    @IBOutlet var flightsTable: WKInterfaceTable!
    
    var flights = Flight.allFlights()
    var selectedIndex = 0
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")
        // Configure interface objects here.
        
        for index in 0..<flightsTable.numberOfRows {
            if let controller = flightsTable.rowController(at: index) as? FlightRowController {
                controller.flight = flights[index]
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let flight = flights[rowIndex]
        selectedIndex = rowIndex
        let controllers = !flight.checkedIn ? ["Flight","CheckIn"] : ["Flight","BoardingPass"]
        presentController(withNames: controllers, contexts: [flight,flight])
    }
    
    override func didAppear() {
        super.didAppear()
        let flight = flights[selectedIndex]
        if flight.checkedIn, let controller = flightsTable.rowController(at: selectedIndex) as? FlightRowController{
            animate(withDuration: 0.2, animations: { 
                controller.updateForCheckIn()
            })
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
