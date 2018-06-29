//
//  CaseCollectionViewCell.swift
//  azertyuio
//
//  Created by Richard Bergoin on 28/05/2018.
//  Copyright © 2018 Richard Bergoin. All rights reserved.
//

import UIKit

class CaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var pionView: UIView!
    @IBOutlet weak var caseBackgroundImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pionView.layer.cornerRadius = frame.size.width / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        pionView.isHidden = false
    }
    
    func getPionView()->UIView{
        return pionView
    }
    
    func configure(withPion pion: PionColor, andBackground background: CaseBackground) {
        
        switch pion {
        case .blanc:
            pionView.backgroundColor = UIColor.white
        case .noir:
            pionView.backgroundColor = UIColor.black
        case .vide:
            pionView.isHidden = true
            
        }
        
        switch background {
        case .dark:
            caseBackgroundImageView.alpha = 1.0
        default:
            caseBackgroundImageView.alpha = 0.5
        }
    }
    
    func checkGesture(lePion : UIView){
        
    }
}
