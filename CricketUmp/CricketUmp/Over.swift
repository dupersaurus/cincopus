//
//  Over.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/22/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation

public class Over {
    
    private let m_iBowlerId:UInt8;
    private var m_iStrikerId:UInt8;
    private var m_iNonStrikerId:UInt8;
    
    /// The number of balls per-over
    private let m_iBallsPerOver:UInt8;
    
    /// All deliveries in the over
    private var m_deliveries:[Delivery];
    
    public init(iBalls:UInt8 = 6, bowler iBowlerId:UInt8, striker iStriker:UInt8, nonStriker iNonStriker:UInt8) {
        m_deliveries = [];
        m_iBallsPerOver = iBalls;
        m_iBowlerId = iBowlerId;
        m_iStrikerId = iStriker;
        m_iNonStrikerId = iNonStriker;
    }
    
    /// The number of balls remaining in the over
    public func getBallsLeft() -> Int8 {
        var iLegalCount = 0;
        
        for delivery in m_deliveries {
            if delivery.isLegalDelivery() {
                iLegalCount++;
            }
        }
        
        return Int8(m_iBallsPerOver) - Int8(iLegalCount);
    }
    
    /**
    Count the total number of runs scored from the over
    
    :returns: The number of runs scored in the over
    */
    public func getOverRuns() -> Score {
        var iRuns:UInt8 = 0;
        var iWickets:UInt8 = 0;
        
        for delivery in m_deliveries {
            iRuns += delivery.totalRuns;
            
            if delivery.wicket != .None {
                iWickets++;
            }
        }
        
        return Score(runs: Int(iRuns), wickets: Int(iWickets));
    }
    
    /**
    Get all deliveries in the over.
    
    :return: An array of all of the over's deliveries
    */
    func getDeliveries() -> [Delivery] {
        return m_deliveries;
    }
    
    /**
    Add a delivery to the over.

    :return: True if the over is complete with this delivery, false otherwise.
    */
    public func addDelivery(delivery:DeliveryResult, wicket:Wicket, runs iRuns:UInt8) -> Bool {
        m_deliveries.append(Delivery(result: delivery, wicket:wicket, runs: iRuns, striker: m_iStrikerId, bowler: m_iNonStrikerId));
        
        return getBallsLeft() == 0;
    }
    
    /**
    Replaces a delivery in the over with new delivery data
    
    :index: the index of the delivery to replace
    
    :delivery: The new delivery data
    
    :return: True on success, false if cannot be done
    */
    public func replaceDeliveryAt(index iIndex:Int, delivery:Delivery) -> Bool {
        if m_deliveries.count <= iIndex {
            return false;
        }
        
        m_deliveries[iIndex] = delivery;
        return true;
    }
    
    /**
    Removes the last delivery
    
    :returns: False if there are no deliveries to undo in the over
    */
    public func undoLastDelivery() -> Bool {
        if m_deliveries.count == 0 {
            return false;
        }
        
        m_deliveries.removeLast();
        return true;
    }
}