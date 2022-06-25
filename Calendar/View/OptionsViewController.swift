//
//  OptionsViewController.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import UIKit
import RealmSwift

class OptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentOptions: Options!
    var images: Results<Options>!
    var imageIsChanged = false
    let userDefaults = UserDefaults()

    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    
    let colorKeys = ["color1", "color2","color3", "color4",
                     "color5", "color6","color7", "color8",
                     "color9", "color10", "color11"]
    
    let cellNames = ["Название месяца", "Названия дней недели","Дни выбранного месяца", "Дни следующего месяца",
                     "Цвет индикатора", "Сегодняшний день", "Выбранный день", "Выбран сегодняшний день",
                     "Выходные дни", "Цвет выбранной даты", "Цвет фона"]
    
    var colorsForCells: [UIColor?] = []
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
    @IBOutlet weak var redValues: UILabel!
    @IBOutlet weak var greenValues: UILabel!
    @IBOutlet weak var blueValues: UILabel!
    @IBOutlet weak var colorCellCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = userDefaults.colorForKey(key: "color11")
        colorCellCollection.delegate = self
        colorCellCollection.dataSource = self
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
        redValues.text = String(format: "%.0f", red)
        changeColorPreview()
    }
    
    @IBAction func greenSliderAction(_ sender: Any) {
        green = CGFloat(greenSlider.value)
        greenValues.text = String(format: "%.0f", green)
        changeColorPreview()
    }
    
    @IBAction func blueSliderAction(_ sender: Any) {
        blue = CGFloat(blueSlider.value)
        blueValues.text = String(format: "%.0f", blue)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCellCollection.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! CustomCollectionViewCell
        let colors = colorsForCells[indexPath.row]
        let cellNames = cellNames[indexPath.row]
        
        cell.cellLabel.text = cellNames
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.58831954, green: 0.6363219619, blue: 0.7316278815, alpha: 1).cgColor
        cell.backgroundColor = colors
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showColorPickerView()
    }
    
    func setDefaultsColors() {
        ColorDefaults.active = true
        
        userDefaults.setColor(color: #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1),
                              forKey: "color1")
        userDefaults.setColor(color: #colorLiteral(red: 0.4406057274, green: 0.4770534495, blue: 0.5300029363, alpha: 1),
                              forKey: "color2")
        userDefaults.setColor(color: #colorLiteral(red: 0.2549019608, green: 0.2745098039, blue: 0.3019607843, alpha: 1),
                              forKey: "color3")
        userDefaults.setColor(color: #colorLiteral(red: 0.4406057274, green: 0.4770534495, blue: 0.5300029363, alpha: 1),
                              forKey: "color4")
        userDefaults.setColor(color: #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
                              forKey: "color5")
        userDefaults.setColor(color: #colorLiteral(red: 0.7139339004, green: 0.3407340069, blue: 0.9686274529, alpha: 1),
                              forKey: "color6")
        userDefaults.setColor(color: #colorLiteral(red: 0.4406057274, green: 0.4770534495, blue: 0.5300029363, alpha: 1),
                              forKey: "color7")
        userDefaults.setColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                              forKey: "color8")
        userDefaults.setColor(color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
                              forKey: "color9")
        userDefaults.setColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                              forKey: "color10")
        
        userDefaults.setColor(color: #colorLiteral(red: 0.4860396981, green: 0.5505498052, blue: 0.666649878, alpha: 1),
                              forKey: "color11")
    }
    
    func loadData() {
        let color1  = userDefaults.colorForKey(key: "color1")
        let color2  = userDefaults.colorForKey(key: "color2")
        let color3  = userDefaults.colorForKey(key: "color3")
        let color4  = userDefaults.colorForKey(key: "color4")
        let color5  = userDefaults.colorForKey(key: "color5")
        let color6  = userDefaults.colorForKey(key: "color6")
        let color7  = userDefaults.colorForKey(key: "color7")
        let color8  = userDefaults.colorForKey(key: "color8")
        let color9  = userDefaults.colorForKey(key: "color9")
        let color10 = userDefaults.colorForKey(key: "color10")
        let color11 = userDefaults.colorForKey(key: "color11")

        let colorsArray = [color1, color2, color3, color4, color5,
                           color6, color7, color8, color9, color10, color11]
        
        colorsForCells = colorsArray
    }
    
    @IBAction func savePopUp(_ sender: Any) {

        guard let indexPath = colorCellCollection?.indexPathsForSelectedItems?.first else {return}
        let currentCellKey = colorKeys[indexPath.row]
        guard colorPreviewValues != nil else { return }
        
        userDefaults.setColor(color: colorPreviewValues, forKey: currentCellKey)
        
        view.backgroundColor = userDefaults.colorForKey(key: "color11")
        loadData()
        colorCellCollection.reloadData()
        colorPickerView.isHidden = true
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
        loadData()
        dismiss(animated: true)
    }
    
    @IBAction func deleteOptionsButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Внимание!", message: "Удалить все настройки?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Да", style: .destructive) { action in
            
            self.setDefaultImage()
            self.setDefaultsColors()
            self.deleteOptions()
            self.dismiss(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "НЕТ!", style: .default) { _ in }
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
