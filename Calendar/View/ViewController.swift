//
//  ViewController.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import UIKit
import RealmSwift
import FSCalendar

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
        
    let searchController = UISearchController(searchResultsController: nil)
    var selectedDate: String! {
        didSet {
            addEventButtonOutlet.isEnabled = true
        }
    }
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM, EEEE, yyyy"
        
        
        return formatter
    }()
    var isFiltering = true
    
    var currentDate = Date()
    var events: Results<Event>!
    var filteredEvents: Results<Event>!
    var datesWithEvent: [String] = []
    var eventText: String?
    var eventNotificationInfo: String?
    
    var bgImage: Results<Options>!
    var backgroundImageData: Data?
    var wallpaper: UIImage? {
        didSet {
            wallpaperView.contentMode = .scaleAspectFill
            wallpaperView.image = wallpaper
        }
    }
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEventButtonOutlet: UIButton!
    @IBOutlet weak var optionsButtonOutlet: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpTF: UITextView!
    @IBOutlet weak var notificationInfoLabel: UILabel!
    @IBOutlet weak var wallpaperView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImage = realm.objects(Options.self)
        events = realm.objects(Event.self)
        
        navigationItem.title = "Сегодня: \(dateFormatter.string(from: currentDate))"
        popUpView.isHidden = true
        addEventButtonOutlet.isEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        
        calendar.delegate = self
        calendar.dataSource = self
        setupSearching()
    }
    
    func setupSearching() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.text = ""
    }
    
    func setUpWallpaper() {
        if backgroundImageData != nil {
            wallpaper = UIImage(data: backgroundImageData!)
        }
    }
    
    func loadData() {
        let imageData = realm.objects(Options.self)
        for image in imageData {
            let data = image.imageData
            backgroundImageData = data
        }
        
        let dateData = realm.objects(Event.self)
        for event in dateData {
            let date = event.date
            datesWithEvent += [date]
            tableView.reloadData()
            calendar.reloadData()
        }
    }
    
    func animationPopUp() {
        popUpView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(10.0),
                       initialSpringVelocity: CGFloat(20.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
            self.popUpView.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
    }
    
    func showPopUp() {
        self.view.bringSubviewToFront(popUpView)
        popUpView.isHidden = false
        popUpTF.backgroundColor = .white
        animationPopUp()
    }
    
    @IBAction func addEventButton(_ sender: Any) {
        performSegue(withIdentifier: "editEvent", sender: nil)
    }
    
    @IBAction func optionsButton(_ sender: Any) {
        performSegue(withIdentifier: "options", sender: nil)
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        popUpView.isHidden = true
    }
    
    @IBAction func editPopUp(_ sender: Any) {
        popUpView.isHidden = true
        performSegue(withIdentifier: "editEvent", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let options = OptionsViewController()
        if ColorDefaults.active == false {
            options.setDefaultsColors()
            options.loadData()
            customizeCalenderAppearance()
            calendar.reloadData()
        } else {
            view.backgroundColor = options.userDefaults.colorForKey(key: "color11")
            customizeCalenderAppearance()
            calendar.reloadData()
            loadData()
            setUpWallpaper()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent" {
            let newEventVC = segue.destination as! NewEventViewController
            
            newEventVC.selectedDate = selectedDate
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let event = isFiltering ? filteredEvents[indexPath.row] : events[indexPath.row]
            newEventVC.currentEvent = event
        }
        
        if segue.identifier == "options" {
            let optionsVC = segue.destination as! OptionsViewController
            
            let options = bgImage
            optionsVC.currentOptions = options?.first
        }
    }
    
    // Passing selected date to searchBar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let stringDate = dateFormatter.string(from: date)
        selectedDate = stringDate
        
        searchController.searchBar.text = selectedDate!
        tableView.reloadData()
    }
    
    // Shows events indication on dates
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let event = isFiltering ? filteredEvents[indexPath.row] : events[indexPath.row]
        cell.eventTextLabel.text = event.eventText
        cell.eventDoneLabel.isHidden = true
        if event.isDone == true {
            cell.eventDoneLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = filteredEvents[indexPath.row]
        eventText = event.eventText
        eventNotificationInfo = event.notificationDate
        popUpTF.text = eventText
        notificationInfoLabel.text = eventNotificationInfo
        showPopUp()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredEvents.count
        }
        return events.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "") { [self] (action, view, completion) in
            let indexesToRedraw = [indexPath]
            let event = self.filteredEvents[indexPath.row]
            
            eventText = event.eventText
            eventNotificationInfo = event.notificationDate

            popUpTF.text = eventText
            notificationInfoLabel.text = eventNotificationInfo

            realm.beginWrite()
            if event.isDone {
                event.isDone = false
            } else {
                event.isDone = true
            }
            try! realm.commitWrite()
            tableView.reloadRows(at: indexesToRedraw, with: .fade)
            tableView.reloadData()
        }
        editAction.backgroundColor = .systemGreen
        let config = UISwipeActionsConfiguration(actions: [editAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let event = filteredEvents[indexPath.row]
            let eventDate = event.date
            StorageManager.deleteObject(event)
            tableView.deleteRows(at: [indexPath], with: .fade)
            let dates = datesWithEvent.filter { $0 != eventDate }
            datesWithEvent = dates
            calendar.reloadData()
        }
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegue" else { return }
    }
    

    func customizeCalenderAppearance() {
        let options = OptionsViewController()
       
        let color1 = options.userDefaults.colorForKey(key: "color1")
        let color2 = options.userDefaults.colorForKey(key: "color2")
        let color3 = options.userDefaults.colorForKey(key: "color3")
        let color4 = options.userDefaults.colorForKey(key: "color4")
        let color5 = options.userDefaults.colorForKey(key: "color5")
        let color6 = options.userDefaults.colorForKey(key: "color6")
        let color7 = options.userDefaults.colorForKey(key: "color7")
        let color8 = options.userDefaults.colorForKey(key: "color8")
        let color9 = options.userDefaults.colorForKey(key: "color9")
        let color10 = options.userDefaults.colorForKey(key: "color10")

        calendar.appearance.caseOptions           = [.headerUsesUpperCase]

        calendar.appearance.weekdayFont           = .boldSystemFont(ofSize: 16)
        calendar.appearance.titleFont             = .boldSystemFont(ofSize: 15)
        calendar.appearance.calendar.firstWeekday =  2
        calendar.appearance.headerTitleColor      =  color1
        calendar.appearance.weekdayTextColor      =  color2
        calendar.appearance.titleDefaultColor     =  color3
        calendar.appearance.titlePlaceholderColor =  color4
        calendar.appearance.eventDefaultColor     =  color5
        calendar.appearance.todayColor            =  color6
        calendar.appearance.selectionColor        =  color7
        calendar.appearance.todaySelectionColor   =  color8
        calendar.appearance.titleWeekendColor     =  color9
        calendar.appearance.titleSelectionColor   =  color10
    }
}
    
    
    
    
    
    




