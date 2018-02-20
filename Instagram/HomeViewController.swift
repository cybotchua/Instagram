//
//  HomeViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBAction func logoutbuttonTaped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell

        return cell
    }
}


