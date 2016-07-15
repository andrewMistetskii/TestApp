//
//  CarCell.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/15/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

public final class CarCell: UITableViewCell, CellIdentifiable {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var carModelLabel: UILabel!
    @IBOutlet private weak var carPriceLabel: UILabel!
    @IBOutlet private weak var carImageView: UIImageView!
    
    public var model: Car? {
        didSet {
            if let model = model {
                carModelLabel.text = model.model
                carPriceLabel.text = model.price
                
                guard let photo = model.photos?.first?.photoData else { return }
                print(photo)
                carImageView.image = UIImage(data: photo)
            }
        }
    }
    
    // MARK: - Lyfecycle
    
    public override func prepareForReuse() {
        carModelLabel.text = ""
        carPriceLabel.text = ""
        carImageView.image = nil
    }
}
