//
//  PhotoAttachable.swift
//  TestApp
//
//  Created by Andrzej Mistetskij on 7/13/16.
//  Copyright © 2016 Swift Devils. All rights reserved.
//

import UIKit
import Photos

private struct LocalizedStringKey {
    
    static let camera              = "Camera"
    static let cameraNotAvailable  = "Camera Not Available"
    static let cameraPermission    = "Please give this app permission to access your camera in your settings app!"
    static let cancel              = "Cancel"
    static let gallery             = "Gallery"
    static let galleryNotAvailable = "Gallery Not Available"
    static let galleryPermission   = "Gallery Permissin"
    static let selectPhoto         = "Select photo"
}


public protocol PhotoAttachable: class, ErrorPresentable {
    
    func attachPhoto()
}

extension PhotoAttachable where Self: UIViewController,
Self: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    public func attachPhoto() {
        let alertController = UIAlertController(title: LocalizedStringKey.selectPhoto, message: "", preferredStyle: .ActionSheet)
        
        let cameraButton = UIAlertAction(title: LocalizedStringKey.camera, style: .Default, handler: cameraAction)
        let cancelActionButton = UIAlertAction(title: LocalizedStringKey.cancel, style: .Cancel, handler: nil)
        let photoLibraryButton = UIAlertAction(title: LocalizedStringKey.gallery, style: .Default, handler: photoLibraryAction)
        
        alertController.addAction(cameraButton)
        alertController.addAction(photoLibraryButton)
        alertController.addAction(cancelActionButton)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    
    private func presentImagePickerControllerWithSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        
        Queue.main.execute({ [weak self] in
            self?.presentViewController(imagePickerController, animated: true, completion: nil)
            })
    }
    
    private func showMessage(message: String) {
        errorPresenter.present(message, animated: true)
    }
    
    // MARK: Camera
    
    private func cameraAction(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            switch AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo) {
            case .Authorized:
                presentImagePickerControllerWithSourceType(.Camera)
            case .NotDetermined:
                requestCameraAccess()
            default:
                showMessage(LocalizedStringKey.cameraPermission)
            }
        } else {
            showMessage(LocalizedStringKey.cameraNotAvailable)
        }
    }
    
    private func requestCameraAccess() {
        AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo) { [weak self] (permitted) in
            guard let strongSelf = self else { return }
            
            if permitted {
                strongSelf.presentImagePickerControllerWithSourceType(.Camera)
            } else {
                strongSelf.showMessage(LocalizedStringKey.cameraPermission)
            }
        }
        
    }
    
    // Photo Library
    
    private func photoLibraryAction(action: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            
            switch PHPhotoLibrary.authorizationStatus() {
            case .Authorized:
                presentImagePickerControllerWithSourceType(.PhotoLibrary)
            case .Denied, .Restricted:
                showMessage(LocalizedStringKey.galleryPermission)
            case .NotDetermined:
                requestPhotoLibraryAccess()
            }
        } else {
            showMessage(LocalizedStringKey.galleryNotAvailable)
        }
    }
    
    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization() { [weak self] (status) -> Void in
            guard let strongSelf = self else { return }
            
            switch status {
            case .Authorized:
                strongSelf.presentImagePickerControllerWithSourceType(.PhotoLibrary)
            case .Denied, .Restricted:
                strongSelf.showMessage(LocalizedStringKey.galleryPermission)
            default:
                break
            }
        }
    }
}

