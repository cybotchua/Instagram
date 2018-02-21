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
            tableView.rowHeight = tableView.frame.height
        }
    }
    
    var ref : DatabaseReference!
    var images : [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        observeFirebase()
    }
    
    func observeFirebase() {
        ref.child("images").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            guard let imageDict = snapshot.value as? [String:Any] else {return}
            let image = Image(imageUID: snapshot.key, imageDict: imageDict)

            DispatchQueue.main.async {
                self.images.append(image)
                let indexPath = IndexPath(row: self.images.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }

            print(snapshot.key)
            print("testing")
        }


    }

    func renderImage(_ urlString: String, cellImageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }

            if let validData = data {
                let image = UIImage(data: validData)

                DispatchQueue.main.async {
                    cellImageView.image = image
                }
            }
        }
        task.resume()
    }

}

extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        count number of post
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTableViewCell", owner: self, options: nil)?.first as! HomeTableViewCell
        
        //delegate
        cell.delegate = self
        cell.index = indexPath
        
        let message = images[indexPath.row]
        cell.captionLabel.text = message.caption
        cell.timeLabel.text = message.timeStampString
//        let purl = user.profilePicURL
//        renderImage(purl, cellImageView: cell.userImage)

//        load image
        let url = message.imageURL
        renderImage(url, cellImageView: cell.homeImageView)
        
        return cell
    }
}

extension HomeViewController : HomeTableViewCellDelegate {
    func didLike(at indexPath: IndexPath) {
        print("Like @", indexPath)
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {return}
        let userPost: [String:Any] = [currentUserID: "true"]
        
        ref.child("likes").child(images[indexPath.row].imageUID).child("users").setValue(userPost)
    }
}
