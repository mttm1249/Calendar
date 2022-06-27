//
//  MainViewController.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import UIKit
import RealmSwift
import FSCalendar

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource {
        
    let colorDefaults = ColorDefaults()

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.data(forKey: "image") != nil {
            wallpaperView.loadImage()
        } else {
            wallpaperView.image = nil
        }
        
        let options = OptionsViewController()
        if colorDefaults.activeDefaultColors == false {
            options.setDefaultsColors()
            options.loadData()
            colorDefaults.customizeAppearanceFor(calendar: calendar)
            calendar.reloadData()
        } else {
            view.backgroundColor = options.userDefaults.colorForKey(key: "color11")
            colorDefaults.customizeAppearanceFor(calendar: calendar)
            calendar.reloadData()
            loadData()
        }
    }
    
    func setupSearching() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.text = ""
    }
        
    func loadData() {
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
        popUpView.applyShadow(shadowRadius: 10)
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
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent" {
            let newEventVC = segue.destination as! NewEventViewController
            
            newEventVC.selectedDate = selectedDate
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let event = isFiltering ? filteredEvents[indexPath.row] : events[indexPath.row]
            newEventVC.currentEvent = event
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue) {
        guard segue.identifier == "unwindSegue" else { return }
    }

}
