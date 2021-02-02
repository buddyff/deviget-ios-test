//
//  DismissAllCell.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 02/02/2021.
//

import UIKit

final class DismissAllCell: UITableViewCell {
    
    @IBOutlet weak var dismissAllBtn: UIButton!
    
    private var callback: (() -> Void)?
    
    func update(callback: @escaping(() -> Void)) {
        self.callback = callback
        dismissAllBtn.addTarget(self, action: #selector(dismissAllTapped), for: .touchUpInside)
    }
    
    @objc private func dismissAllTapped(sender: Any?) {
        callback?()
    }
}
