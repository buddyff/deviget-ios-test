//
//  File.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 02/02/2021.
//

import UIKit

final class PaginationCell: UITableViewCell {
    
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    private var prevCallback: (() -> Void)?
    private var nextCallback: (() -> Void)?
    
    func update(prevCallback: (() -> Void)?, nextCallback: (() -> Void)?) {
        previousBtn.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextBtn.setImage(UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
        
        if let prevCallback = prevCallback {
            self.prevCallback = prevCallback
            previousBtn.addTarget(self, action: #selector(prevTapped), for: .touchUpInside)
            previousBtn.isHidden = false
        } else {
            previousBtn.isHidden = true
        }
        
        if let nextCallback = nextCallback {
            self.nextCallback = nextCallback
            nextBtn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
            nextBtn.isHidden = false
        } else {
            nextBtn.isHidden = true
        }        
    }
    
    @objc func prevTapped(sender: Any?) {
        prevCallback?()
    }
    
    @objc func nextTapped(sender: Any?) {
        nextCallback?()
    }
    
}
