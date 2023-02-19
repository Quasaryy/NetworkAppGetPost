//
//  CollectionViewController.swift
//  NetworkAppGetPost
//
//  Created by Yury on 18.02.23.
//

import UIKit

enum RequestTypes: String, CaseIterable {
    case get = "GET Request"
    case post = "POST Request"
}


class CollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    let requests = RequestTypes.allCases
    var users = User(results: [])
    let insetForSection = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let cellsInRow: CGFloat = 4
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return requests.count
        } else {
            return users.results.count
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let requestsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "requestTypesCell", for: indexPath) as! RequestTypesCollectionViewCell
            
            // Configure the cell
            requestsCell.configureCell(requests: requests, indexPath: indexPath)
            return requestsCell
        }
        else {
            let usersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "usersCell", for: indexPath) as! UsersCollectionViewCell
            
            // Configure the cell
            usersCell.configureCell(model: users, indexPath: indexPath)
            return usersCell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let request = requests[indexPath.item]
            
            switch request {
            case .get:
                getData()
            case .post:
                postRequest()
            }
        }
    }
    
}


// MARK: Cell size
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        } else {
            return insetForSection
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 250, height: 80)
        } else {
            let availableWidth = collectionView.frame.width
            let cellSize = (availableWidth - insetForSection.left * (cellsInRow + 1)) / cellsInRow
            let size = CGSize(width: cellSize, height: cellSize)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            return 40
        } else {
            return 10
        }
    }
    
}

extension CollectionViewController {
    // MARK: Alert Controller
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let buttoonOK = UIAlertAction(title: "OK", style: .default)
        alert.addAction(buttoonOK)
        present(alert, animated: true)
    }
    
    // MARK: Post request
    private func postRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        users.results.append(Result(
            name: Name(title: "Ms",
                       first: "Eva",
                       last: "English"),
            picture: Picture(large: "https://randomuser.me/api/portraits/med/women/44.jpg",
                             medium: "https://randomuser.me/api/portraits/med/women/44.jpg",
                             thumbnail: "https://randomuser.me/api/portraits/med/women/44.jpg")))
        
        let userData = try? JSONEncoder().encode(users)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = userData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)")
                    return
                }
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                do {
                    self.users = try JSONDecoder().decode(User.self, from: data)
                    print(response.statusCode)
                    
                    DispatchQueue.main.async {
                        self.showAlert(title: "Success", message: "Model sucessfully encoded and decoded with POST request with status code: \(response.statusCode)")
                    }
                }
                catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Decoding Error", message: error.localizedDescription)
                    }
                }
                
            }
        }.resume()
    }
    
    // MARK: Get request
    func getData() {
        guard let url = URL(string: "https://randomuser.me/api/?results=50") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "\(error.localizedDescription)")
                }
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                
                do {
                    self.users = try JSONDecoder().decode(User.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                            self.showAlert(title: "Success", message: "Model sucessfully decoded with GET request with status code: \(response.statusCode)")
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.showAlert(title: "Decoder error", message: "\(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
}
