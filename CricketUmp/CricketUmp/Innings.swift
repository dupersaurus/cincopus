//
//  Innings.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/24/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation

public class Innings {
    
    /// The game the innings is a member of
    private let m_game:Game;
    
    private let m_iBattingTeamId:UInt16;
    
    /// Overs that make up the innings
    private var m_overs:[Over];
    
    /// The index of the current over
    private var m_currentOver:Int;
    
    /// Number of overs in an innings
    private let m_iOverLimit:UInt8;
    
    /// Running tally of the innings score, updated on each completed over.
    private var m_iInningsScore:UInt16;
    
    /// The time the innings was started at
    private var m_startDate:NSDate?;
    
    private var m_timer:Timer?;
    
    public init(game:Game, overs iOvers:UInt8, battingId iBattingTeamId:UInt16 = 0) {
        m_game = game;
        m_iOverLimit = iOvers;
        m_iBattingTeamId = iBattingTeamId;
        
        m_iInningsScore = 0;
        m_currentOver = 0;
        m_overs = [];
        m_startDate = nil;
        
        m_timer = Timer(fInterval: 0.1, tickCallback: onTimerTick);
    }
    
    /**
    Returns the number of overs that have been completed.
    
    :returns: A tuple with two members:
        "overs" (Int) is the number of overs fully completed;
        "balls" (Int8) is the number of legal deliveries made in the current over
    */
    public func getOversCompleted() -> OverCount {
        return OverCount(completedOvers: m_currentOver, balls: 6 - m_overs[m_currentOver].getBallsLeft());
    }
    
    /**
    Begin the innings
    */
    func beginPlay() {
        m_startDate = NSDate();
        m_timer?.start();
        
        createNewOver();
    }
    
    /**
    Pause the innings timer
    */
    func pauseInnings() {
        m_timer?.stop();
    }
    
    /**
    Adds a delivery to the current over
    */
    public func addDelivery(delivery:DeliveryResult, wicket:Wicket, batterRuns iRuns:Int) {
        
        // Over is completed
        var bNew:Bool = m_overs[m_currentOver].addDelivery(delivery, wicket: wicket, runs: UInt8(iRuns))
        m_game.updateScore(countScore());
        m_game.updateOvers(countOvers());
        
        if bNew {
            createNewOver();
        }
    }
    
    /**
    Get a list of the last deliveries.
    
    :param: count The number of deliveries to get.
    
    :returns: An array of deliveries up to the given count
    */
    public func getLastDeliveries(count iCount:Int) -> [Delivery] {
        var deliveries:[Delivery] = [];
        var overDeliveries:[Delivery];
        
        for var iOvers = m_overs.count - 1; iOvers >= 0; iOvers-- {
            overDeliveries = m_overs[iOvers].getDeliveries();
            
            for var iBalls = overDeliveries.count - 1; iBalls >= 0; iBalls-- {
                deliveries.append(overDeliveries[iBalls]);
                
                if deliveries.count >= iCount {
                    break;
                }
            }
            
            if deliveries.count >= iCount {
                break;
            }
        }
        
        return deliveries;
    }
    
    // MARK: - Callbacks
    
    /**
    Called by the timer on each tick
    
    :fTime: The current time of the timer
    */
    func onTimerTick(fTime:NSTimeInterval) {
        m_game.updateTimer(fTime);
    }
    
    // MARK: - Internals
    
    /**
    Create a new over and set it as current
    */
    private func createNewOver() {
        m_overs.append(Over(iBalls: 6, bowler: 0, striker: 0, nonStriker: 0));
        m_currentOver = m_overs.count - 1;
    }
    
    /**
    Count the current score of the innings
    
    :returns: A Score object containing the current runs and wickets
    */
    private func countScore() -> Score {
        var iRuns = 0;
        var iWickets = 0;
        var overScore:Score;
        
        for over in m_overs {
            overScore = over.getOverRuns();
            iRuns += Int(overScore.runs);
            iWickets += Int(overScore.wickets);
        }
        
        return Score(runs: iRuns, wickets: iWickets);
    }
    
    /**
    Count how many overs have been completed in the over
    
    :returns: An OverCount object with the current overs and balls
    */
    private func countOvers() -> OverCount {
        var iOvers = m_overs.count - 1;
        var iBalls = 0;
        
        if let ballsRemaining = m_overs.last?.getBallsLeft() {
            /*if ballsRemaining == 0 {
                iOvers++;
            } else {*/
                iBalls = 6 - Int(ballsRemaining);
            //}
        }
        
        return OverCount(completedOvers: iOvers, balls: iBalls);
    }
}