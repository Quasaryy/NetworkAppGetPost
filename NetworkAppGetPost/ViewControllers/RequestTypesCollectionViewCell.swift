//
//  CollectionViewCell.swift
//  NetworkAppGetPost
//
//  Created by Yury on 18.02.23.
//

import UIKit

class RequestTypesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var requestTypeLabel: UILabel!
    
}

extension RequestTypesCollectionViewCell {
    func configureCell(requests: [RequestTypes], indexPath: IndexPath) {
        self.backgroundColor = .systemYellow
        self.requestTypeLabel.font = .systemFont(ofSize: 22)
        self.layer.cornerRadius = 10
        self.requestTypeLabel.text = requests[indexPath.item].rawValue
    }
}
