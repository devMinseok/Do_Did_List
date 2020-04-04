//
//  NewToDoTableViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/03/08.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class NewToDoTableViewController: UITableViewController {
    
    let modelManager = ModelManager()
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        self.contentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        onDidChangeDate(timePicker)
        
        timePicker.isHidden = true
        arrowDirection()
        
        starRatingView.settings.fillMode = .half
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setObserver()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let item = ToDoItem(title: titleField.text!,
                            firstColor: firstColorData!,
                            secondColor: secondColorData!,
                            imageData: imageData!,
                            timestamp: timePicker.date,
                            importance: starRatingView.rating,
                            content: contentTextView.text,
                            isDone: false)
        
        modelManager.add(item)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onDidChangeDate(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh:mm a"
        
        let selectDate = dateFormatter.string(from: sender.date)
        
        timeLabel.text = selectDate
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc private func handleIcon(notification: Notification) {
        guard let iconDict = notification.userInfo else { return }
        guard let icon = iconDict["finalIcon"] as? UIImage else { return }
        iconButton.setBackgroundImage(icon, for: .normal)
    }
    
    func arrowDirection() {
        let imageName = timePicker.isHidden ? "Popover Arrow Down" : "Popover Arrow Up"
        arrowImageView.image = UIImage(named: imageName)
    }
    
    func setObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleIcon), name: NSNotification.Name(rawValue: "finalIcon"), object: nil)
    }
}


// MARK: - UITableViewDelegate
extension NewToDoTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1 {
            let height: CGFloat = timePicker.isHidden ? 0.0 : 216.0
            return height
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timeIndexPath1 = NSIndexPath(row: 0, section: 1) as IndexPath
        let timeIndexPath2 = NSIndexPath(row: 2, section: 1) as IndexPath
        
        if timeIndexPath1 == indexPath || timeIndexPath2 == indexPath {
            
            timePicker.isHidden = !timePicker.isHidden
            
            UIView.animate(withDuration: 0.25) {
                self.tableView.beginUpdates()
                // apple bug fix - some TV lines hide after animation
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.tableView.endUpdates()
            }
            
            arrowDirection()
        }
    }
}

// MARK: - UITextFieldDelegate

extension NewToDoTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.titleField){
            self.titleField.resignFirstResponder()
        }
        return true
    }
}
