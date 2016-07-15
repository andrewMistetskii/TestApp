//
//  AddCarTableViewController.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/12/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import Photos

public final class AddCarTableViewController: UITableViewController, PhotoAttachable, CoreDataCompatible {
    
    private enum Defaults {
        static let extraCell = 1
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var carModelTextField: UITextField!
    @IBOutlet private weak var priceTextField: UITextField!
    @IBOutlet private weak var conditionTextField: UITextField!
    @IBOutlet private weak var transmissionTextField: UITextField!
    @IBOutlet private weak var engineTextField: UITextField!
    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private weak var pictureCollectionView: UICollectionView!
    @IBOutlet private weak var previousPictureButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Private Properties
    private let etfToolbar = UIToolbar()
    private var pickToolbar = UIToolbar()
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.whiteColor()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    
    private var pictureDataSource: [UIImage] = []
    private var pictureURLs: [String] = []
    private let engineDataSource: [String] = ["In-line-3-cylinder", "In-line-4-cylinder", "In-line-6-cylinder", "V6-cylinder", "V8-cylinder", "V10-cylinder", "V12-cylinder"]
    private let transmissionDataSource: [String] = ["Automatic", "Manual"]
    private let conditionDataSource: [String] = ["Excellent", "Good", "Fair", "Poor"]
    
    private var selectedEngine       = 0
    private var selectedTransmission = 0
    private var selectedCondition    = 0
    
    private lazy var saveCarBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveCar))
        return item
    }()
    
    // MARK: - CoreDataCompatible
    
    public var coreDataStack: CoreDataStack!
    
    // MARK: - IBActions
    
    @IBAction private func previousPictureAction(sender: AnyObject) {
        // TODO: add implementation
    }
    
    @IBAction private func nextPictureAction(sender: AnyObject) {
        // TODO: add implementation
    }
   
    @IBAction func engineAction(sender: AnyObject) {
        pickerView.reloadAllComponents()
        setUpInitialValue(engineTextField, dataSource: engineDataSource, selectedItem: selectedEngine)
    }
    
    @IBAction func transmissionAction(sender: AnyObject) {
        pickerView.reloadAllComponents()
        setUpInitialValue(transmissionTextField, dataSource: transmissionDataSource, selectedItem: selectedTransmission)
    }
    
    @IBAction func conditionAction(sender: AnyObject) {
        pickerView.reloadAllComponents()
        setUpInitialValue(conditionTextField, dataSource: conditionDataSource, selectedItem: selectedCondition)
    }
    
    // MARK: - Lifecycle
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpTextFieldsPlaceholders()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureInputAccessoryToolbarForEditableTextFields()
        configureInputAccessoryToolbarForPickerTextFields()
        setUpEditableTextFields()
        setUpTextFieldsWithPickerView()
        setUpTextView()
        navigationItem.rightBarButtonItem = saveCarBarButtonItem
        navigationItem.title = "Add Car"
        navigationController?.navigationBar.setBottomBorderColor(UIColor.whiteColor(), height: 1.0)
        setUpCollectionView()
    }
    
    // MARK: - Private Methods
    
    @objc private func saveCar() {
        print("save car")
        let car = Car()
        car.model = carModelTextField.text
        car.price = priceTextField.text
        car.engine = engineTextField.text
        car.transmission = transmissionTextField.text
        car.condition = conditionTextField.text
        car.carDescription = descriptionTextView.text
        var photos: [CarPhoto] = []
        
        for image in pictureDataSource {
            let photo = CarPhoto()
            photo.photoData = UIImageJPEGRepresentation(image, 0.5)
            photos.append(photo)
        }
        car.photos = photos
        
        do {
            try coreDataStack.managedObjectContext.save()
            if let navigationController = self.navigationController {
                navigationController.popViewControllerAnimated(true)
            }
        } catch {
            fatalError(FatalError.CoreData.managedObjectContextFailedSaveData)
        }
    }
    
    private func setUpCollectionView() {
        registerNibs()
        pictureCollectionView.delegate = self
        pictureCollectionView.dataSource = self
    }
    
    private func setUpTextFieldsPlaceholders() {
        carModelTextField.setPlaceholder("Enter car model", withColor: UIColor.whiteColor())
        priceTextField.setPlaceholder("Enter car price", withColor: UIColor.whiteColor())
        conditionTextField.setPlaceholder("Choose condition", withColor: UIColor.whiteColor())
        transmissionTextField.setPlaceholder("Choose transmission", withColor: UIColor.whiteColor())
        engineTextField.setPlaceholder("Choose engine", withColor: UIColor.whiteColor())
    }
    
    private func registerNibs() {
        pictureCollectionView.registerNib(AddPictureCollectionViewCell.nib, forCellWithReuseIdentifier: AddPictureCollectionViewCell.identifier)
    }
    
    private func configureInputAccessoryToolbarForEditableTextFields() {
        
        let okButton = UIBarButtonItem(title: "Ok", style: .Plain, target: self, action: #selector(hideKeyboard))
        okButton.tintColor = UIColor.blackColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        etfToolbar.barStyle = .Default
        etfToolbar.items = [spaceButton, okButton]
        etfToolbar.sizeToFit()
    }
    
    private func configureInputAccessoryToolbarForPickerTextFields() {
        let clearButton = UIBarButtonItem(title: "Clear", style: .Plain, target: self, action: #selector(clearTextField))
        clearButton.tintColor = UIColor.blackColor()
        let okButton = UIBarButtonItem(title: "Ok", style: .Plain, target: self, action: #selector(hideKeyboard))
        okButton.tintColor = UIColor.blackColor()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        
        pickToolbar.barStyle = .Default
        pickToolbar.items = [clearButton, spaceButton, okButton]
        pickToolbar.sizeToFit()
    }
    
    @objc private func hideKeyboard() {
        getFirstResponder()?.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @objc private func clearTextField() {
        guard let textField = getFirstResponder() as? UITextField else { return }
        textField.text = ""
    }
    
    private func getFirstResponder() -> UIView? {
        for cell in tableView.visibleCells {
            if let contentView = cell.subviews.first {
                for subview in contentView.subviews {
                    if let textField = subview as? UITextField where textField.isFirstResponder() {
                        return textField
                    }
                }
            }
        }
        return nil
    }
    
    private func setUpEditableTextFields() {
        carModelTextField.inputAccessoryView = etfToolbar
        priceTextField.inputAccessoryView = etfToolbar
    }
    
    private func setUpTextFieldsWithPickerView() {
        engineTextField.textColor = UIColor.whiteColor()
        engineTextField.inputView = pickerView
        engineTextField.inputAccessoryView = pickToolbar
        
        transmissionTextField.textColor = UIColor.whiteColor()
        transmissionTextField.inputView = pickerView
        transmissionTextField.inputAccessoryView = pickToolbar
        
        conditionTextField.textColor = UIColor.whiteColor()
        conditionTextField.inputView = pickerView
        conditionTextField.inputAccessoryView = pickToolbar
    }
    
    private func setUpTextView() {
        descriptionTextView.inputAccessoryView = etfToolbar
    }
    
    private func setUpInitialValue(textField: UITextField, dataSource: [String], selectedItem: Int) {
        guard textField.text!.isEmpty else {
            pickerView.selectRow(selectedItem, inComponent: 0, animated: true)
            return
        }
        textField.text = dataSource.first
        pickerView.selectRow(0, inComponent: 0, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension AddCarTableViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension AddCarTableViewController: UICollectionViewDataSource {
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureDataSource.count + Defaults.extraCell
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard indexPath.row != pictureDataSource.count else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(AddPictureCollectionViewCell.identifier, forIndexPath: indexPath) as! AddPictureCollectionViewCell
            cell.delegate = self
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PreviewCarCollectionViewCell.identifier, forIndexPath: indexPath) as! PreviewCarCollectionViewCell
        cell.image = pictureDataSource[indexPath.row]
        
        return cell
    }
}

// MARK: - UIImagePickerControllerDelegate

extension AddCarTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    public func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        pictureDataSource.append(image)
        
        pictureCollectionView.reloadData()
        pictureCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: pictureDataSource.count, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        guard error == nil else {
            // TODO: handle error
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
        fetchLastImage { (localIdentifier) in
            if let localIdentifier = localIdentifier {
                let result = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil)
                let assets = result.objectsAtIndexes(NSIndexSet(indexesInRange: NSRange(location: 0, length: result.count))) as? [PHAsset] ?? []
                
                if let asset = assets.first {
                    PHImageManager.defaultManager().requestImageDataForAsset(asset, options: nil, resultHandler: { [weak self] (data, dataUTI, imageOrientation, info: [NSObject : AnyObject]?) in
                        guard let strongSelf = self else { return }
                        if let data = data,
                               info = info,
                               imageURL = info["PHImageFileURLKey"] as? NSURL {
                            
                            let newImage = UIImage(data: data)!
                            strongSelf.pictureDataSource.append(newImage)
                            strongSelf.pictureURLs.append(imageURL.absoluteString)
                            strongSelf.pictureCollectionView.reloadData()
                            strongSelf.pictureCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: strongSelf.pictureDataSource.count, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
                        }
                    })
                }
            }
        }
    }
    
    private func fetchLastImage(completion: (localIdentifier: String?) -> Void)
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        if (fetchResult.firstObject != nil)
        {
            let lastImageAsset: PHAsset = fetchResult.firstObject as! PHAsset
            completion(localIdentifier: lastImageAsset.localIdentifier)
        }
        else
        {
            completion(localIdentifier: nil)
        }
    }
}

// MARK: - AddPictureCollectionViewCellDelegate

extension AddCarTableViewController: AddPictureCollectionViewCellDelegate {
    public func didTapAddPictureButton() {
        attachPhoto()
    }
}

// MARK: - UITextViewDelegate

extension AddCarTableViewController: UITextViewDelegate {

    public func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = !textView.text.isEmpty
        resizeCellForGivenTextView(textView)
    }

    private func resizeCellForGivenTextView(textView: UITextView) {
        let size = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.max))
        
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: 5, inSection: 0), atScrollPosition: .Bottom, animated: false)
        }
    }
}

// MARK: - UITableViewDelegate

extension AddCarTableViewController {
    
    public override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    public override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension AddCarTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let textField = getFirstResponder() as? UITextField else { return  1}
        if textField == transmissionTextField {
            return transmissionDataSource.count
        } else if textField == conditionTextField {
            return conditionDataSource.count
        } else {
            return engineDataSource.count
        }
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let textField = getFirstResponder() as? UITextField else { return }
        if textField == transmissionTextField {
            transmissionTextField.text = transmissionDataSource[row]
            selectedTransmission = row
        } else if textField == conditionTextField {
            conditionTextField.text = conditionDataSource[row]
            selectedCondition = row
        } else {
            engineTextField.text = engineDataSource[row]
            selectedEngine = row
        }
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let textField = getFirstResponder() as? UITextField else { return  ""}
        if textField == transmissionTextField {
            return transmissionDataSource[row]
        } else if textField == conditionTextField {
            return conditionDataSource[row]
        } else {
            return engineDataSource[row]
        }
    }
}





