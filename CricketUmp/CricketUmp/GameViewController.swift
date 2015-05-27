//
//  GameViewController.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/26/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation
import UIKit

class GameViewController : UIViewController {
    
    // MARK: - Member variables
    private var m_game:Game?;
    
    /// Completed over count
    private var m_overs:OverCount = (0,0);
    
    private var m_userDefaults:NSUserDefaults?;
    
    // MARK: - ViewController interface
    /// Label displays the current innings time
    @IBOutlet weak var m_inningsTimerLabel: UILabel!
    
    /// Label displays the current over rate
    @IBOutlet weak var m_overRateLabel: UILabel!
    
    /// Label displays the score and wickets
    @IBOutlet weak var m_scoreLabel: UILabel!
    
    @IBOutlet weak var m_deliveryResults: UISegmentedControl!
    /**
    Called by buttons to set the number of runs/extras scored.
    
    :param: sender The button that was selected. The tag of the object denotes how many runs.
    */
    @IBAction func selectScoredRuns(sender: UIButton) {
        m_game?.getCurrentInnings()?.addDelivery(getCurrentDeliveryResult(), wicket: Wicket.None, batterRuns: sender.tag);
    }
    
    /**
    Called when the delivery result control is changed
    */
    @IBAction func changeResultType(sender: UISegmentedControl) {
        
    }
    
    /**
    Called by the wicket button
    */
    @IBAction func selectWicket(sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        m_userDefaults = NSUserDefaults.standardUserDefaults();
        
        startGame(Game(innings: 1, overs: 40, homeTeam: 0, awayTeam: 0));
    }
    
    // MARK: - Game management
    private func getCurrentDeliveryResult() -> DeliveryResult {
        switch m_deliveryResults.selectedSegmentIndex {
        case 0:
            return DeliveryResult.Legal;
        case 1:
            return DeliveryResult.Byes;
        case 2:
            return DeliveryResult.LegByes
        case 3:
            return DeliveryResult.Wide;
        case 4:
            return DeliveryResult.NoBall;
            
        default:
            return DeliveryResult.Legal;
        }
    }
    
    func startGame(game:Game) {
        m_game = game;
        m_game?.setTimerTickCallback(onTimerTick);
        m_game?.setUpdateOversCallback(onOversChange);
        m_game?.setUpdateScoreCallback(onScoreChange);
        
        onOversChange(0, balls: 0);
        onScoreChange(0, wickets: 0);
        onTimerTick(0);
        
        m_game?.letsPlay();
    }
    
    // MARK: - Callbacks
    
    /**
    Called by the game when the over count changes
    */
    func onOversChange(completed:Int, balls:Int) {
        m_overs.overs = completed;
        m_overs.balls = balls;
    }
    
    /**
    Called by the game when the score changes
    */
    func onScoreChange(runs:Int, wickets:Int) {
        if m_userDefaults!.boolForKey("aussieStyle") {
            m_scoreLabel.text = "\(wickets)/\(runs)";
        } else {
            m_scoreLabel.text = "\(runs)/\(wickets)";
        }
    }
    
    /**
    Called by the game when the timer changes
    */
    func onTimerTick(time:NSTimeInterval) {
        m_inningsTimerLabel.text = Timer.getTimeString(timeInSeconds: time);
        
        if (m_overs.overs > 0 && m_overs.balls > 0) {
            let fOverPct:Double = Double(m_overs.overs) + Double(m_overs.balls) / 6;
            let fOverRate = time / fOverPct;
            m_overRateLabel.text = Timer.getTimeString(timeInSeconds: fOverRate);
        } else {
            m_overRateLabel.text = "--";
        }
    }
}