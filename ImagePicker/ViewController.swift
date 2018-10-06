//
//  ViewController.swift
//  ImagePicker
//
//  Created by Rish on 06/10/18.
//  Copyright © 2018 Rish. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import SVProgressHUD

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var imageArray = [UIImage]()
    var selectedAssets = [PHAsset]()
    
    let importButton : UIButton = {
       let button = UIButton()
        button.setTitle("IMPORT IMAGES", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleImportTap), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
       let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 10
        cv.layer.shadowColor = UIColor.black.cgColor
        cv.layer.shadowOffset = CGSize(width: 5, height: 5)
        cv.layer.shadowRadius = 5
        cv.layer.shadowOpacity = 1
        return cv
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        imageArray = [UIImage(named: "image-1")] as! [UIImage]
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: cellId)
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        view.addSubview(importButton)
        importButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        importButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        importButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        importButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        
    }
    
    let vc = BSImagePickerViewController()
    
    @objc func handleImportTap() {
        
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
                                            
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            
            for i in 0..<assets.count {
                self.imageArray = [UIImage]()
                self.selectedAssets.append(assets[i])
            }
            self.convertAssetToImages()
        }, completion: nil)
        
    }
    
    func convertAssetToImages() -> Void{
        SVProgressHUD.show()
        for i in 0..<selectedAssets.count {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            
            manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: option, resultHandler: {(result,info) -> Void in
                thumbnail = result!
            })
            
            let data = thumbnail.jpegData(compressionQuality: 0.7)
            let newImage = UIImage(data: data!)
            self.imageArray.append(newImage! as UIImage)

            DispatchQueue.main.async {
                 self.collectionView.reloadData()
            }
           
           
          
        }
        
         SVProgressHUD.dismiss()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImagesCell
        cell.mainImage.image = imageArray[indexPath.row]
        return cell 
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 8, height: collectionView.frame.height - 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
    }
}

