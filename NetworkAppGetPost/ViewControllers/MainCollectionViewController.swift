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
        guard indexPath.item == 1 else { return }
        showAlert()
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
    private func showAlert() {
        let alert = UIAlertController(title: "Success", message: "Model sucessfull encoded and decoded with POST request.", preferredStyle: .alert)
        let buttoonOK = UIAlertAction(title: "OK", style: .default)
        alert.addAction(buttoonOK)
        present(alert, animated: true)
    }
    
    // MARK: Post request
    private func postRequest() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            <#code#>
        }
    }
    
}
