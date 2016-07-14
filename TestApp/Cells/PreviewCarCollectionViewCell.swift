//
//  PreviewCarCollectionViewCell.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

public final class PreviewCarCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var previewCarImageView: UIImageView!
    
    // MARK: - Public Properties
    
    public var image: UIImage? {
        didSet {
            if let image = image {
                previewCarImageView.image = image
            }
        }
    }
}
