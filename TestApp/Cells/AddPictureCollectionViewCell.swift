//
//  AddPictureCollectionViewCell.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit

public protocol AddPictureCollectionViewCellDelegate: class {
    func didTapAddPictureButton()
}

public final class AddPictureCollectionViewCell: UICollectionViewCell, CellIdentifiable {

    public weak var delegate: AddPictureCollectionViewCellDelegate?
    
    @IBAction func addPictureAction(sender: AnyObject) {
        delegate?.didTapAddPictureButton()
    }
}
