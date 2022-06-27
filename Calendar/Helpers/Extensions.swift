//
//  Extensions.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import FSCalendar
import UIKit

// MARK: - Searching filter

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredEvents = events.filter("date CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
}

// MARK: - UIImagePickerController

extension OptionsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func chooseImagePicker(source: UIImagePickerController.SourceType) {

        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        bgImage.image = info[.editedImage] as? UIImage
        bgImage.clipsToBounds = true
        dismiss(animated: true)
    }
}

// MARK: - Hide Keyboard Method

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UserDefaults

extension UserDefaults {
  func colorForKey(key: String) -> UIColor? {
    var colorReturnded: UIColor?
    if let colorData = data(forKey: key) {
      do {
        if let color = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor {
          colorReturnded = color
        }
      } catch {
        print("Error UserDefaults")
      }
    }
    return colorReturnded
  }
  
  func setColor(color: UIColor?, forKey key: String) {
    var colorData: NSData?
    if let color = color {
      do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false) as NSData?
        colorData = data
      } catch {
        print("Error UserDefaults")
      }
    }
    set(colorData, forKey: key)
  }
}

extension UIImageView {
    func saveImage(){
        guard let image = self.image, let data = image.jpegData (compressionQuality: 1.0) else { return }
      let encoded = try! PropertyListEncoder().encode (data)
      UserDefaults.standard.set(encoded, forKey: "image")
    }
    
    func loadImage() {
        guard let data = UserDefaults.standard.data(forKey: "image") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        let image = UIImage(data: decoded)
        self.image = image
    }
}

// MARK: - Working with shadows
extension UIView {
    func applyShadow(shadowRadius: CGFloat) {
        layer.cornerRadius = shadowRadius
        layer.masksToBounds = false
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
}
