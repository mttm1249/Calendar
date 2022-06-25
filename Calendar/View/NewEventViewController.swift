//
//  NewEventViewController.swift
//  Calendar
//
//  Created by Денис on 27.03.2022.
//

import UIKit

class NewEventViewController: UIViewController {
    
    var currentEvent: Event!
    var selectedDate: String?
    var notificationIsEnabled: Bool?
    var notificationDate = ""
    
    let colors = OptionsViewController()
    let notifications = Notifications()
    
    @IBOutlet weak var eventTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationDateOptions: UIStackView!
    @IBOutlet weak var switcher: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        notificationDateOptions.isHidden = true
        notificationIsEnabled = false
        datePicker.minimumDate = Date()
        navigationItem.title = selectedDate
        setupEditScreen()
    }
        
    private func setupEditScreen() {
        view.backgroundColor = colors.userDefaults.colorForKey(key: "color11")
        guard currentEvent != nil else { return }
        eventTextView.text = currentEvent.eventText
        if currentEvent.withNotification == true {
            notificationIsEnabled = true
            switcher.isOn = true
            notificationDateOptions.isHidden = false
        }
    }
    
    @IBAction func notificationSwitchAction(_ sender: Any) {
        notificationIsEnabled?.toggle()
        animation()
        notificationDateOptions.isHidden.toggle()
    }
    
    func animation() {
        notificationDateOptions.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        
        UIStackView.animate(withDuration: 0.7,
                            delay: 0,
                            usingSpringWithDamping: CGFloat(10.0),
                            initialSpringVelocity: CGFloat(20.0),
                            options: UIStackView.AnimationOptions.allowUserInteraction,
                            animations: {
            self.notificationDateOptions.transform = CGAffineTransform.identity
        },
                            completion: { Void in()  }
        )
    }
    
    @IBAction func saveEventButton(_ sender: Any) {
        let date = datePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        let calendar = Calendar.current
        
        let year = calendar.dateComponents([.year], from: date)
        let month = calendar.dateComponents([.month], from: date)
        let day = calendar.dateComponents([.day], from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if notificationIsEnabled == true {
            notificationDate = formatter.string(from: date)
        } else {
            notificationDate = "Напоминание - откл."
        }
        
        let newEvent = Event(eventText: eventTextView.text, date: selectedDate!, isDone: false, withNotification: notificationIsEnabled!, notificationDate: notificationDate)
        
        if currentEvent != nil {
            try! realm.write {
                currentEvent.eventText = newEvent.eventText
                currentEvent.date = newEvent.date
                currentEvent.isDone = newEvent.isDone
                currentEvent.notificationDate = newEvent.notificationDate
                currentEvent.withNotification = newEvent.withNotification
            }
        } else {
            StorageManager.saveObject(newEvent)
        }
        
        if notificationIsEnabled == true {
            notifications.scheduleNotification(notificationText: eventTextView.text,
                                               hours: hour,
                                               minutes: minutes,
                                               year: year.year!,
                                               month: month.month!,
                                               day: day.day!,
                                               identifier: eventTextView.text)
        }
        
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
}
