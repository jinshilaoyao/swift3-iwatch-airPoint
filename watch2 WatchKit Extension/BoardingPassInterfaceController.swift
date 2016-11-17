//
//  BoardingPassInterfaceController.swift
//  watch2
//
//  Created by yesway on 2016/11/17.
//  Copyright © 2016年 joker. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController {
    
    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var boardingPassImage: WKInterfaceImage!

    var session: WCSession? {
        didSet {
            session?.delegate = self
            session?.activate()
        }
    }
    
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
            }
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let flight = context as? Flight {
            self.flight = flight
        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        if let flight = flight , flight.boardingPass == nil && WCSession.isSupported() {
            session = WCSession.default()
            
            session?.sendMessage(["reference": flight.reference], replyHandler: { (replay) in
                
                if let boardingPassData = replay["boardingPassData"] as? Data, let boardingPass = UIImage(data: boardingPassData) {
                    flight.boardingPass = boardingPass
                    DispatchQueue.main.async {
                        self.showBoardingPass()
                    }
                }
                
                }, errorHandler: { (error) in
                    print(error)
            })
        }
    }
    
    private func showBoardingPass() {
        boardingPassImage.stopAnimating()
        boardingPassImage.setWidth(120)
        boardingPassImage.setHeight(120)
        boardingPassImage.setImage(flight?.boardingPass)
    }
}

extension BoardingPassInterfaceController: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print(activationState)
    }
}
