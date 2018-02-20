//
//  SearchViewController.swift
//  Instagram
//
//  Created by Lih Heng Yew on 19/02/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

/*THINGS TO DO
 collection view //
 search bar //
 tableview lists all users
 profile pic
 username
 email
 no of new posts (image/vids)
 counter +1 for each new post, reset to 0 when tapped
 filter for search bar
 */

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    var ref : DatabaseReference!
    var images : [Image] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        observeFireBase()
        
    }
    
    func searchBarTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SearchBarViewController") as? SearchBarViewController else {return}
        
        present(vc, animated: true, completion: nil)
    }
    
    func observeFireBase() {
        
        //CHILD ADDED
        ref.child("images").observe(.childAdded) { (snapshot) in
            
            guard let imageDict = snapshot.value as? [String : Any] else {return}
            
                let image = Image(imageUID: snapshot.key, imageDict: imageDict)
                
                DispatchQueue.main.async {
                    self.images.append(image)
                    let indexPath = IndexPath(row: self.images.count - 1, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                }
            
            print(snapshot)
        }
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let collectionViewImage = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = collectionViewImage
                }
            }
        }
        task.resume()
    }
}

extension SearchViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? PictureCollectionViewCell else {return UICollectionViewCell()}
        
        if let imageViewForCell = cell.imageView {
            
            let picURL = images[indexPath.row].imageURL
            
            getImage(picURL, imageViewForCell)
        }
        
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarTapped()
        return false
    }
}
