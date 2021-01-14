//
//  ActiveGrid.swift
//  Instagrid
//
//  Created by Johann on 11/01/2021.
//

import UIKit

class ActiveGrid: UIView {
    
    // variables pour les vues et bouttons
    
    @IBOutlet weak var layout1: UIButton!
    @IBOutlet weak var layout2: UIButton!
    @IBOutlet weak var layout3: UIButton!
    
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var bottomView: UIStackView!
    @IBOutlet weak var topLeftView: UIButton!
    @IBOutlet weak var topRightView: UIButton!
    @IBOutlet weak var bottomLeftView: UIButton!
    @IBOutlet weak var bottomRightView: UIButton!


    // enum Layout Bouttons
    enum Display {
        case layoutT, layoutReverseT, fourSquare
    }
    
    // display default
    var activeDisplay: Display = .layoutReverseT {
        didSet {
            currentLayout(activeDisplay)
        }
    }
    // radius correction
    func viewRadius() {
        topLeftView.layer.cornerRadius = 5
        topRightView.layer.cornerRadius = 5
        bottomLeftView.layer.cornerRadius = 5
        bottomRightView.layer.cornerRadius = 5

    }
    
    // display selection
     private func currentLayout(_ layoutDisplay: Display) {
        switch layoutDisplay {
        case .layoutT:
            layout1.setImage(UIImage(named: "Selected"), for: .normal)
            layout2.imageView?.isHidden = true
            layout3.imageView?.isHidden = true
            topRightView.isHidden = true
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false

            
        case .layoutReverseT:
            layout2.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.imageView?.isHidden = true
            layout3.imageView?.isHidden = true
            bottomRightView.isHidden = true
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomLeftView.isHidden = false
            

        case .fourSquare:
            layout3.setImage(UIImage(named: "Selected"), for: .normal)
            layout1.imageView?.isHidden = true
            layout2.imageView?.isHidden = true
            topRightView.isHidden = false
            topLeftView.isHidden = false
            bottomRightView.isHidden = false
            bottomLeftView.isHidden = false
        }
    }

        

}
