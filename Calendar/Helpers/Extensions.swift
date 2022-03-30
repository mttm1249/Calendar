//
//  Extensions.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import FSCalendar
import UIKit

// MARK: FSCalendar Appearance

extension FSCalendar {
    
    func customizeCalenderAppearance() {
        self.appearance.caseOptions           = [.headerUsesUpperCase]
        
        self.appearance.weekdayFont           = .boldSystemFont(ofSize: 16)
        self.appearance.titleFont             = .boldSystemFont(ofSize: 15)
        self.appearance.calendar.firstWeekday =  2
        self.appearance.headerTitleColor      =  #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
        self.appearance.weekdayTextColor      =  #colorLiteral(red: 0.4406057274, green: 0.4770534495, blue: 0.5300029363, alpha: 1)
        self.appearance.titleDefaultColor     =  #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1)
        self.appearance.titlePlaceholderColor =  #colorLiteral(red: 0.4406057274, green: 0.4770534495, blue: 0.5300029363, alpha: 1)
        self.appearance.eventDefaultColor     =  #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.appearance.todayColor            =  #colorLiteral(red: 0.7139339004, green: 0.3407340069, blue: 0.9686274529, alpha: 1)
        self.appearance.selectionColor        = .gray
        self.appearance.todaySelectionColor   = .black
        self.appearance.titleWeekendColor     = .red
        self.appearance.titleSelectionColor   = .white
    }
}

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
