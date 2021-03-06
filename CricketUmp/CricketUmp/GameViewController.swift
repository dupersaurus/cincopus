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
    private var m_overs:OverCount?;
    
    private var m_userDefaults:NSUserDefaults?;
    
    @IBOutlet var m_deliveries: [DeliveryView]!
    
    private var m_pendingWicket:Wicket = .None;
    
    // MARK: - Other View Controllers
    private var m_scoreVC:ScoreViewController?;
    
    // MARK: - ViewController interface
    /// Label displays the current innings time
    @IBOutlet weak var m_inningsTimerLabel: UILabel!
    
    /// Label displays the current over rate
    @IBOutlet weak var m_overRateLabel: UILabel!
    
    /// Label displays the score and wickets
    @IBOutlet weak var m_scoreLabel: UILabel!
    
    @IBOutlet weak var m_overCountLabel: UILabel!
    @IBOutlet weak var m_deliveryResults: UISegmentedControl!
    
    /**
    Called by buttons to set the number of runs/extras scored.
    
    :param: sender The button that was selected. The tag of the object denotes how many runs.
    */
    @IBAction func selectScoredRuns(sender: UIButton) {
        
        // TODO: Run this through the game, not the innings directly
        var bDone:Bool? = m_game?.getCurrentInnings()?.addDelivery(getCurrentDeliveryResult(), wicket: m_pendingWicket, batterRuns: sender.tag)
        
        if bDone != nil && !(bDone!) {
            m_game?.getCurrentInnings()?.pauseInnings();
            showScoreDisplay();
        }
        
        m_pendingWicket = .None;
    }
    
    /**
    Called when the delivery result control is changed
    */
    @IBAction func changeResultType(sender: UISegmentedControl) {
        
    }
    
    @IBAction func toggleTimer(sender: AnyObject) {
        m_game?.getCurrentInnings()?.toggleInningsTimer();
    }
    
    /**
    Called by the wicket button
    */
    @IBAction func selectWicket(sender: UIButton) {
        m_pendingWicket = Wicket.Bowled;
    }
    
    @IBAction func undoLastBall(sender: AnyObject) {
        m_game?.getCurrentInnings()?.undoLastDelivery();
    }
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        m_userDefaults = NSUserDefaults.standardUserDefaults();
        
        startGame(Game(innings: 1, overs: 40, homeTeam: 0, awayTeam: 0));
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
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
        
        onOversChange(OverCount());
        onScoreChange(Score());
        onTimerTick(0);
        
        m_game?.letsPlay();
    }
    
    func nextInnings() {
        m_game?.letsPlay();
        
        onOversChange(OverCount());
        onScoreChange(Score());
        onTimerTick(0);
    }
    
    func showScoreDisplay() {
        if m_scoreVC == nil {
            m_scoreVC = self.storyboard!.instantiateViewControllerWithIdentifier("scoreScreen") as? ScoreViewController;
        }
        
        presentViewController(m_scoreVC!, animated: true, completion: nil);
        
        m_scoreVC?.setGame(m_game!, vc: self);
    }
    
    // MARK: - Callbacks
    
    /**
    Called by the game when the over count changes
    */
    func onOversChange(count:OverCount) {
        m_overs = count;
        
        if (m_overs != nil) {
            m_overCountLabel.text = "Overs: \((m_overs?.overs)!).\((m_overs?.balls)!) of \((m_game?.oversPerInnings)!)";
        } else {
            m_overCountLabel.text = "Overs: 0.0 of \((m_game?.oversPerInnings)!)";
        }
        
        let lastDeliveries:[Delivery]? = m_game?.getCurrentInnings()?.getLastDeliveries(count: 6);
        var overTracker:OverCount = count;
        
        for var i = 0; i < m_deliveries.count; i++ {
            if i >= lastDeliveries?.count {
                m_deliveries[i].empty();
            } else {
                m_deliveries[i].setDelivery(overTracker, delivery: lastDeliveries![i]);
                
                if lastDeliveries![i].isLegalDelivery() {
                    overTracker = overTracker--;
                }
            }
        }
    }
    
    /**
    Called by the game when the score changes
    */
    func onScoreChange(score: Score) {
        if m_userDefaults!.boolForKey("aussieStyle") {
            m_scoreLabel.text = "\(score.wickets)/\(score.runs)";
        } else {
            m_scoreLabel.text = "\(score.runs)/\(score.wickets)";
        }
    }
    
    /**
    Called by the game when the timer changes
    */
    func onTimerTick(time:NSTimeInterval) {
        m_inningsTimerLabel.text = Timer.getTimeString(timeInSeconds: time);
        
        if (m_overs?.overs == 0 && m_overs?.balls == 0) {
            m_overRateLabel.text = "--";
        } else {
            let fOverPct:Double = Double((m_overs?.overs)!) + Double((m_overs?.balls)!) / 6;
            let fOverRate = time / fOverPct;
            m_overRateLabel.text = Timer.getTimeString(timeInSeconds: fOverRate) + " min/over";
        }
    }
}