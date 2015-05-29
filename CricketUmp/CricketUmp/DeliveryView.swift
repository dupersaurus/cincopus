//
//  DeliveryView.swift
//  CricketUmp
//
//  Created by Jason DuPertuis on 5/27/15.
//  Copyright (c) 2015 jdp. All rights reserved.
//

import Foundation
import UIKit

class DeliveryView: UIView {
    
    private var m_resultLabel:UILabel?;
    private var m_runsLabel:UILabel?;
    private var m_overLabel:UILabel?;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        m_resultLabel = viewWithTag(1) as? UILabel;
        m_runsLabel = viewWithTag(2) as? UILabel;
        m_overLabel = viewWithTag(3) as? UILabel;
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        
        m_resultLabel = viewWithTag(1) as? UILabel;
        m_runsLabel = viewWithTag(2) as? UILabel;
        m_overLabel = viewWithTag(3) as? UILabel;
        
        m_resultLabel?.text = "";
        m_runsLabel?.text = "";
        m_overLabel?.text = "";
    }
    
    func setDelivery(over:OverCount, delivery:Delivery) {
        
        m_runsLabel!.text = "\(delivery.extraRuns)";
        m_overLabel!.text = "\(over.overs).\(over.balls)";
        
        var sResult:String = "";
        
        switch delivery.result {
        case .Legal:
            sResult = "";
            
        case .Wide:
            sResult = "wd";
        
        case .NoBall:
            sResult = "nb";
            
        case .Byes:
            sResult = "b";
            
        case .LegByes:
            sResult = "lb";
        }
        
        if delivery.wicket != .None {
            sResult = "W\(sResult)";
        }
        
        m_resultLabel!.text = sResult;
    }
}