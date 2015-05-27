//
//  Definitions.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/26/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation

public enum Team {
    case None
    case Home
    case Away
}

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
}

/**
Definitions for all possible wicket types
*/
public enum Wicket {
    case None
    case Bowled
    case Caught
    case RunOut
    case Stumped
    case LBW
    case HandledBall
    case HitWicket
    case Obstruction
    case TimedOut
    case HitBallTwice
    case Retired
}

public typealias OverCount = (overs:Int, balls:Int)

/// A handy wrapper for passing scores, easier than having to tuple everywhere.
public struct Score {
    private let m_iRuns:Int;
    private let m_iWickets:Int;
    
    init(runs iRuns:Int, wickets iWickets:Int) {
        m_iRuns = iRuns;
        m_iWickets = iWickets;
    }
    
    /// Number of runs scored in the over
    public var runs:Int {
        return m_iRuns;
    }
    
    /// Number of wickets scored in the over
    public var wickets:Int {
        return m_iWickets;
    }
}