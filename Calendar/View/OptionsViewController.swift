//
//  OptionsViewController.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import UIKit
import RealmSwift

class OptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var currentColors: Colors!
    
    var test: Colors!
    
    var currentOptions: Options!
    var images: Results<Options>!
    var colors: Results<Colors>!
    var imageIsChanged = false
    let colorsData = realm.objects(Colors.self)
    
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var colorPreviewValues: UIColor? {
        didSet {
            colorPreview.backgroundColor = colorPreviewValues
        }
    }
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var colorPreview: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var colorCellCollection: UICollectionView!
    
    var colorStrings: [String?] = []
    var currentString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colors = realm.objects(Colors.self)

        
        colorCellCollection.delegate = self
        colorCellCollection.dataSource = self
        
        deleteButton.isHidden = true
        colorPickerView.isHidden = true
        setupOptionsScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func changeColorPreview() {
        colorPreviewValues = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    }
    
    @IBAction func redSliderAction(_ sender: Any) {
        red = CGFloat(redSlider.value)
        changeColorPreview()
    }
    @IBAction func greenSliderAction(_ sender: Any) {
        green = CGFloat(greenSlider.value)
        changeColorPreview()
    }
    @IBAction func blueSliderAction(_ sender: Any) {
        blue = CGFloat(blueSlider.value)
        changeColorPreview()
    }
    
    
    func showColorPickerView() {
        view.bringSubviewToFront(colorPickerView)
        colorPickerView.isHidden = false
        animationPopUp()
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        colorPickerView.isHidden = true
    }
    
    
    func stringToColor(color string: String) {
        //        let result = string.components(separatedBy: " ")
        //
        //        let redString = result[1]
        //        let greenString = result[2]
        //        let blueString = result[3]
        //
        //        let red = Double(redString)! * 255
        //        let green = Double(greenString)! * 255
        //        let blue = Double(blueString)! * 255
        
        //        section1 = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let colorsData = realm.objects(Colors.self)
        for color in colorsData {
            colorStrings = [color.headerTitleColor, color.weekdayTextColor, color.titleDefaultColor,
                      color.titlePlaceholderColor, color.eventDefaultColor, color.todayColor,
                      color.selectionColor, color.todaySelectionColor, color.titleWeekendColor,
                      color.titleSelectionColor
            ]
        }
        return colorStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCellCollection.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        
        cell.backgroundColor = .red
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = colorStrings[indexPath.row]

        currentString = cell
        
        showColorPickerView()
        
        print("CURRENT CELL: \(cell!)")
    }
    
    let colorString = "HELLO"
    
    func saveColorsData() {
        let newColors = Colors(headerTitleColor: colorString,
                               weekdayTextColor: colorString,
                               titleDefaultColor: colorString,
                               titlePlaceholderColor: colorString,
                               eventDefaultColor: colorString,
                               todayColor: colorString,
                               selectionColor: colorString,
                               todaySelectionColor: colorString,
                               titleWeekendColor: colorString,
                               titleSelectionColor: colorString)
        if currentColors != nil {
            try! realm.write {
                currentColors.headerTitleColor = colorString
                currentColors.weekdayTextColor = colorString
                currentColors.titleDefaultColor = colorString
                
                currentColors.titlePlaceholderColor = colorString
                currentColors.eventDefaultColor = colorString
                currentColors.todayColor = colorString
                
                currentColors.selectionColor = colorString
                currentColors.todaySelectionColor = colorString
                currentColors.titleWeekendColor = colorString
                currentColors.titleSelectionColor = colorString
            }
        } else {
            StorageManager.saveColors(newColors)
        }
    }
    
    
    // todo
    
    
    @IBAction func savePopUp(_ sender: Any) {
        
        guard let indexPath = colorCellCollection?.indexPathsForSelectedItems?.first else {return}

        let current = colorStrings[indexPath.row]
        
        print("CURRENT: \(current!)")

        print("INDEXPATH: \(indexPath)")
        
        realm.beginWrite()

        

        try! realm.commitWrite()
        
//        print("CURRENT: \(currentCell)")
        
        print("цвет из слайдеров \(colorPreviewValues!)")
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
    
    func animationPopUp() {
        colorPickerView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(10.0),
                       initialSpringVelocity: CGFloat(20.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            self.colorPickerView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    
    
    @IBAction func saveOptionsButton(_ sender: UIButton) {
        saveChanges()
        //        dismiss(animated: true)
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
    
    
    func loadData() {
        
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
