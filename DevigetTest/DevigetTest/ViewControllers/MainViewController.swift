//
//  MainViewController.swift
//  DevigetTest
//
//  Created by Rodrigo Camparo on 01/02/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UINib(nibName: "PostCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        table.dataSource = self
        
    }


}


extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let myCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
            else { return UITableViewCell() }
        
        myCell.update(read: false, author: "Rodrigo Ignacio Camparo", picture: nil, title: "Lorem ipsum", comments: "19 comments")
        
        return myCell
    }
    
    
}

