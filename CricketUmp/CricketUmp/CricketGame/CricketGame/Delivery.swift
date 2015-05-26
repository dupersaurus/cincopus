//
//  Delivery.swift
//  CricketGame
//
//  Created by Jason DuPertuis on 5/22/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation

/**
    All of the possible scoring results of a delivery.

    - *Legal* is a legal delivery
    - *Byes* for byes
    - *LegByes* for leg byes
    - *Wide* for a wide ball
    - *NoBall* for a no-ball
    - *Wicket* for a wicket
 */
public enum DeliveryResult {
    case Legal
    case Byes
    case LegByes
    case Wide
    case NoBall
    case Wicket
}

public class Delivery {
    /** Id of the bowler for the delivery */
    private let m_iBowlerId:UInt8;
    
    /** Id of the batter for the delivery */
    private let m_iBatterId:UInt8;
    
    /** The result of the delivery */
    private let m_result:DeliveryResult;
    
    /** The number of runs/extras scored from the delivery. 
    Does not count the wide or no ball penalty run. */
    private let m_iRuns:UInt8;
    
    /**
      Creates a delivery
    
      :result: The result of the delivery
    
      :runs: The number of runs or extras scored. Does not include wide and no ball bonus run.
    
      :striker: Id of the striker
    
      :bowler: Id of the bowler
     */
    public init(result:DeliveryResult, runs iRuns:UInt8, striker iBatterId:UInt8 = 0, bowler iBowlerId:UInt8 = 0) {
        m_iBatterId = iBatterId;
        m_iBowlerId = iBowlerId;
        
        m_result = result;
        m_iRuns = iRuns;
    }
    
    /// The result of the delivery
    public var result:DeliveryResult {
        return m_result;
    }
    
    /// Number of extra runs scored. For wide and no-ball, runs without the penalty. Otherwise, exactly the same as totalRuns.
    public var extraRuns:UInt8 {
        return m_iRuns;
    }
    
    /// The total number of runs scored, counting wide and no-ball penalty
    public var totalRuns:UInt8 {
        switch m_result {
        case .Wide, .NoBall:
            return m_iRuns + 1;
            
        default:
            return m_iRuns;
        }
    }
    
    /**
        Returns if the delivery is a legal delivery
    
        :return: True if legal delivery, false if not
    */
    public func isLegalDelivery() -> Bool {
        switch m_result {
        case .Wide, .NoBall:
            return false;
            
        default:
            return true;
        }
    }
}