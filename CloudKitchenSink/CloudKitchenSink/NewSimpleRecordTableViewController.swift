//
//  NewSimpleRecordTableViewController.swift
//  CloudKitchenSink
//
//  Created by aluno on 18/08/18.
//  Copyright © 2018 Guilherme Rambo. All rights reserved.
//


import UIKit
import CloudKit
import CoreLocation
 

class NewSimpleRecordTableViewController: UITableViewController {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //define the name`s record
    var record = CKRecord(recordType: "Movie")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        
        view.addGestureRecognizer(tap)
        
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func titleFieldAction(_ sender: Any) {
        guard let title = titleField.text else { return }
        
        record[.title] = title
    }
    
    @IBAction func releaseDateFieldAction(_ sender: Any) {
        guard let dateString = dateField.text else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else { return }
        
        record[.releaseDate] = date
    }
    
    @IBAction func locationFieldAction(_ sender: Any) {
        guard let locationString = locationField.text else { return }
        
        CLGeocoder().geocodeAddressString(locationString) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            
            self.record[.location] = placemark.location
            
            DispatchQueue.main.async {
                self.locationField.text = String(placemark)
            }
        }
    }
    
    @IBAction func ratingSliderAction(_ sender: Any) {
        let value = Int(ceil(ratingSlider.value))
        
        record[.rating] = value
    }
    
    @IBAction func save(_ sender: Any) {
        saveButton.isEnabled = false
        saveButton.isHidden = true
        activityIndicator.startAnimating()
        
        container.publicCloudDatabase.save(record) { [unowned self] _, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.saveButton.isEnabled = true
                self.saveButton.isHidden = false
                
                if let error = error {
                    let alert = UIAlertController(title: "CloudKit error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.clear()
                }
            }
        }
    }
    
    private func clear() {
        titleField.text = nil
        dateField.text = nil
        locationField.text = nil
        ratingSlider.value = 0
        
        record = CKRecord(recordType: "Movie")
        
        _ = titleField.becomeFirstResponder()
        _ = dateField.becomeFirstResponder()
        _ = locationField.becomeFirstResponder()
        
    }
}
