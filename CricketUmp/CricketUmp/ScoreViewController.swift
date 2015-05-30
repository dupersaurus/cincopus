//
//  ScoreViewController.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/29/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController : UIViewController {
    
    
    @IBOutlet weak var m_taScoreLabel: UILabel!
    @IBOutlet weak var m_taOverRateLabel: UILabel!
    @IBOutlet weak var m_tbScoreLabel: UILabel!
    @IBOutlet weak var m_tbOverRateLabel: UILabel!
    @IBOutlet weak var m_playButton: UIButton!
    
    private var m_vc:GameViewController?;
    
    override func viewDidLoad() {
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    @IBAction func letsPlay(sender: AnyObject) {
        m_vc?.nextInnings();
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    /// Populate with information from the game
    func setGame(game:Game, vc:GameViewController) {
        m_vc = vc;
        var inningsInfo:(innings:[Innings], numInnings:UInt8) = game.getInnings();
        var innings:Innings;
        var overs:OverCount;
        var score:Score;
        var time:NSTimeInterval;
        var fRunRate:Double;
        var fOverRate:Double;
        
        // Only first innings done
        if (inningsInfo.innings.count >= 1) {
            innings = inningsInfo.innings[0];
            overs = innings.getOversCompleted();
            score = innings.getScore();
            time = innings.getInningsTime();
            fRunRate = Double(score.runs) / (Double(overs.overs) + (Double(overs.balls) / 6.0));
            fOverRate = (Double(overs.overs) + (Double(overs.balls) / 6.0)) / (time / 3600.0);
            
            fRunRate = floor(fRunRate * 100) * 0.01;
            fOverRate = floor(fOverRate * 100) * 0.01;
            
            m_taScoreLabel.text = "\(score.runs)/\(score.wickets) \(overs.overs).\(overs.balls)o (\(fRunRate)rr)";
            m_taOverRateLabel.text = "\(fOverRate) o/hr";
        } else {
            m_taScoreLabel.text = "Not Played";
            m_taOverRateLabel.text = "";
        }
        
        // Second innings done
        if (inningsInfo.innings.count >= 2) {
            innings = inningsInfo.innings[1];
            overs = innings.getOversCompleted();
            score = innings.getScore();
            time = innings.getInningsTime();
            fRunRate = Double(score.runs) / (Double(overs.overs) + (Double(overs.balls) / 6.0));
            fOverRate = (Double(overs.overs) + (Double(overs.balls) / 6.0)) / (time / 3600.0);
            
            fRunRate = floor(fRunRate * 100) * 0.01;
            fOverRate = floor(fOverRate * 100) * 0.01;
            
            m_tbScoreLabel.text = "\(score.runs)/\(score.wickets) \(overs.overs).\(overs.balls)o (\(fRunRate)rr)";
            m_tbOverRateLabel.text = "\(fOverRate) o/hr";
        } else {
            m_tbScoreLabel.text = "Not Played";
            m_tbOverRateLabel.text = "";
        }
        
        if inningsInfo.innings.count >= Int(inningsInfo.numInnings) * 2 {
            m_playButton.hidden = true;
        }
    }
}