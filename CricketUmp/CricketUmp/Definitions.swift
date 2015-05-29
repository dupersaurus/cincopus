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

/// Wrapper for passing around the over count of an innings.
public struct OverCount {
    private let m_iCompleted:Int;
    private let m_iBalls:Int;
    
    init() {
        m_iCompleted = 0;
        m_iBalls = 0;
    }
    
    init (completedOvers iOvers:Int, balls iBalls:Int) {
        m_iCompleted = iOvers;
        m_iBalls = iBalls;
    }
    
    /// Number of fully completed overs
    public var overs:Int {
        return m_iCompleted;
    }
    
    /// Number of balls in the current over
    public var balls:Int {
        return m_iBalls;
    }
}

postfix func ++ (over:OverCount) -> OverCount {
    var iNewBalls = over.balls + 1;
    var iNewOvers = over.overs;
    
    if iNewBalls > 6 {
        iNewOvers++;
        iNewBalls -= 6;
    }
    
    return OverCount(completedOvers: iNewOvers, balls: iNewBalls);
}

postfix func -- (over:OverCount) -> OverCount {
    var iNewBalls = over.balls - 1;
    var iNewOvers = over.overs;
    
    if iNewBalls < 0 {
        iNewOvers--;
        iNewBalls += 6;
    }
    
    return OverCount(completedOvers: iNewOvers, balls: iNewBalls);
}

/// A handy wrapper for passing scores, easier than having to tuple everywhere.
public struct Score {
    private let m_iRuns:Int;
    private let m_iWickets:Int;
    
    init() {
        m_iRuns = 0;
        m_iWickets = 0;
    }
    
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