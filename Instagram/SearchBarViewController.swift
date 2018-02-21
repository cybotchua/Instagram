//
//  SearchBarViewController.swift
//  Instagram
//
//  Created by Terence Chua on 20/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SearchBarViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 80
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var ref : DatabaseReference!
    var profiles : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()

        observeFireBase()
        
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let tableViewImage = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = tableViewImage
                }
            }
        }
        task.resume()
    }
    
    func observeFireBase() {
        
        //CHILD ADDED
        ref.child("users").observe(.childAdded) { (snapshot) in
            
            guard let userDict = snapshot.value as? [String : Any] else {return}
            
            if userDict["email"] as? String != Auth.auth().currentUser?.email {
            
                let user = User(uid: snapshot.key, userDict: userDict)
                
                DispatchQueue.main.async {
                    self.profiles.append(user)
                    let indexPath = IndexPath(row: self.profiles.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
            
            print(snapshot)
        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }


}

extension SearchBarViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        
        if let imageViewForCell = cell.profileImageView {
            
            cell.usernameLabel.text = profiles[indexPath.row].username
            
            cell.emailLabel.text = profiles[indexPath.row].email
            
            let picURL = profiles[indexPath.row].profilePicURL
            
            getImage(picURL, imageViewForCell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let email = profiles[indexPath.row].email
//        let username = profiles[indexPath.row].username
//        let profilePicURL = profiles[indexPath.row].profilePicURL
//        let uid = profiles[indexPath.row].uid
//        
//        let selectedUser = User(uid: uid, userDict: ["email" : email, "username" : username, "profilePicURL" : profilePicURL])
        

        
    }
    
}
