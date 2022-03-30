//
//  NewEventViewController.swift
//  wefwefw
//
//  Created by Денис on 27.03.2022.
//

import Foundation
import UIKit

class NewEventViewController: UIViewController {
    
    var currentEvent: Event!
    var selectedDate: String?
    
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTextView.becomeFirstResponder()
        
        guard let selectedDate = self.selectedDate else { return }
        eventDateLabel.text = selectedDate
        setupEditScreen()
    }
    
    private func setupEditScreen() {
        if currentEvent != nil {
            eventTextView.text = currentEvent.eventText
        }
    }
    
    @IBAction func saveEventButton(_ sender: Any) {
        let newEvent = Event(eventText: eventTextView.text, date: selectedDate!, isDone: false)
        if currentEvent != nil {
            try! realm.write {
                currentEvent.eventText = newEvent.eventText
                currentEvent.date = newEvent.date
                currentEvent.isDone = newEvent.isDone
            }
        } else {
            StorageManager.saveObject(newEvent)
        }
        performSegue(withIdentifier: "unwindSegue", sender: nil)
    }
}
