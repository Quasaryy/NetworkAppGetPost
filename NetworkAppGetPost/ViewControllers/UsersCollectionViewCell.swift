//
//  UsersCollectionViewCell.swift
//  NetworkAppGetPost
//
//  Created by Yury on 19.02.23.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var userImage: UIImageView!
    
}

extension UsersCollectionViewCell {
    func configureCell(model: User, indexPath: IndexPath) {
        self.layer.cornerRadius = 10
        guard let url = URL(string: model.results[indexPath.item].picture.medium) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            
            guard let dataSource = data else { return }
            let imageSource = UIImage(data: dataSource)
            DispatchQueue.main.async {
                self.userImage.image = imageSource
            }
        }.resume()
    }
    
}
