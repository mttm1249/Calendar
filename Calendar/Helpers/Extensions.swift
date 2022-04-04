//
//  Extensions.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import FSCalendar
import UIKit


// MARK: Searching filter

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredEvents = events.filter("date CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
}

// MARK: Work with UIImagePickerController

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
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}



