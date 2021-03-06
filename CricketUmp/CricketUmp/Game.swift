//
//  Game.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/24/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation

public class Game {
    
    // MARK: - Member variables
    private let m_iHomeId:UInt16;
    private let m_iAwayId:UInt16;
    
    /// Who won the toss
    private var m_wonToss:Team;
    
    /// Who bats first
    private var m_batFirst:Team;
    
    /// Number of innings for the game, per team
    private let m_iNumInnings:UInt8;
    
    /// Number of overs per inning
    private let m_iNumOvers:UInt8;
    
    public var oversPerInnings:UInt8 {
        return m_iNumOvers;
    }
    
    /// Innings for the game
    private var m_innings:[Innings];
    
    // MARK: - Callbacks to the view controller
    
    /// Update the innings time
    private var m_cbTimerTick:((elapsedTime:NSTimeInterval)->Void)?;
    
    /**
    Set the method to call when the timer is updated
    
    :param: callback The callback
    */
    public func setTimerTickCallback(callback:((elapsedTime:NSTimeInterval)->Void)?) {
        m_cbTimerTick = callback;
    }
    
    /// Update the over count
    private var m_cbUpdateOvers:((count:OverCount)->Void)?;
    
    /**
    Set the method to call when the over is updated
    
    :param: callback The callback
    */
    public func setUpdateOversCallback(callback:((count:OverCount)->Void)?) {
        m_cbUpdateOvers = callback;
    }
    
    /// Update the score and wickets
    private var m_cbUpdateScore:((score:Score)->Void)?;
    
    /**
    Set the method to call when the score is updated
    
    :param: callback The callback
    */
    public func setUpdateScoreCallback(callback:((score:Score)->Void)?) {
        m_cbUpdateScore = callback;
    }
    
    // MARK: - Init
    /**
    Create a game
    
    :param: innings The number of innings per team
    
    :param: overs The number of overs per team
    */
    init(innings iInnings:UInt8, overs iOvers:UInt8, homeTeam iHome:UInt16 = 0, awayTeam iAway:UInt16 = 0) {
        m_iHomeId = iHome;
        m_iAwayId = iAway;
        m_iNumInnings = iInnings;
        m_iNumOvers = iOvers;
        
        m_innings = [];
        m_wonToss = Team.None;
        m_batFirst = Team.None;
    }
    
    // MARK: - Input from the view controller
    
    /**
    Set results of the coin toss
    
    :wonToss: Which team won the toss
    
    :batsFirst: Which team bats first
    */
    public func setTossResults(wonToss:Team, batsFirst:Team) {
        m_wonToss = wonToss;
        m_batFirst = batsFirst;
    }
    
    /**
    Begin playing the current inning
    */
    public func letsPlay() {
        m_innings.append(Innings(game: self, overs: m_iNumOvers, battingId: 0));
        m_innings.last?.beginPlay();
    }
    
    // MARK: - Input from the game components
    
    /**
    An innings has been concluded
    
    :innings: the innings that is concluded
    */
    func inningsConcluded() {
        
    }
    
    func updateScore(score:Score) {
        m_cbUpdateScore?(score: score);
    }
    
    func updateOvers(overs:OverCount) {
        m_cbUpdateOvers?(count: overs);
    }
    
    func updateTimer(fTime:NSTimeInterval) {
        m_cbTimerTick?(elapsedTime: fTime);
    }
    
    // MARK: - Information
    
    /**
    Returns the current innings.
    */
    public func getCurrentInnings() -> Innings? {
        return m_innings.last;
    }
    
    public func getInnings() -> (innings:[Innings], numInnings:UInt8) {
        return (m_innings, m_iNumInnings);
    }
}