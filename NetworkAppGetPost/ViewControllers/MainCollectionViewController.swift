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


class MainCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    let requests = RequestTypes.allCases
    var users = User(results: [])
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requests.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        // Configure the cell
        
        cell.backgroundColor = .systemYellow
        cell.requestTypeLabel.font = .systemFont(ofSize: 22)
        cell.layer.cornerRadius = 10
        cell.requestTypeLabel.text = requests[indexPath.item].rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let request = requests[indexPath.item]
        
        switch request {
        case .get:
            showAlert(title: "Success", message: "Model sucessfull encoded and decoded with POST request.")
        case .post:
            postRequest()
        }
    }
    
}


// MARK: Cell size
extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 250, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
}

extension MainCollectionViewController {
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
                        self.showAlert(title: "Success", message: "Model sucessfull encoded and decoded with POST request with status code: \(response.statusCode)")
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
    
}
