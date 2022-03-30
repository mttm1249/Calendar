//
//  OptionsViewController.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import UIKit
import RealmSwift

class OptionsViewController: UIViewController {
    
    var currentOptions: Options!
    var images: Results<Options>!
    var imageIsChanged = false
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.isHidden = true
        setupOptionsScreen()
    }
    
    @IBAction func changeBgImageButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Сделать снимок", style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction(title: "Выбрать из галереи", style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Закрыть", style: .destructive )
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true)
    }
    
    func buttonAnimation(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.9,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(10.0),
                       initialSpringVelocity: CGFloat(20.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    @IBAction func saveOptionsButton(_ sender: UIButton) {
        buttonAnimation(sender)
        saveChanges()
        dismiss(animated: true)
    }
    
    @IBAction func deleteOptionsButton(_ sender: Any) {
        setDefaultImage()
        deleteOptions()
        dismiss(animated: true)
    }
    
    func deleteOptions() {
        guard currentOptions != nil else { return }
        images = realm.objects(Options.self)
        let image = images.first
        StorageManager.deleteOptions(image!)
    }
    
    func setDefaultImage() {
        let image =  #imageLiteral(resourceName: "defaultBg")
        let imageData = image.pngData()
        let newOptions = Options(imageData: imageData)
        try! realm.write {
            currentOptions?.imageData = newOptions.imageData
        }
        StorageManager.saveOptions(newOptions)
    }
    
    func saveChanges() {
        let image = imageIsChanged ? bgImage.image : #imageLiteral(resourceName: "defaultBg")
        let imageData = image?.pngData()
        let newOptions = Options(imageData: imageData)
        
        if currentOptions != nil {
            try! realm.write {
                currentOptions?.imageData = newOptions.imageData
            }
        } else {
            StorageManager.saveOptions(newOptions)
        }
    }
    
    private func setupOptionsScreen() {
        if currentOptions != nil {
            imageIsChanged = true
            guard let data = currentOptions?.imageData, let image = UIImage(data: data) else { return }
            bgImage.image = image
            bgImage.contentMode = .scaleAspectFill
            deleteButton.isHidden = false
        }
    }
}
