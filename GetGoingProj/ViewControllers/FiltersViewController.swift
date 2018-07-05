//
//  FiltersViewController.swift
//  GetGoingProj
//
//  Created by MCDA5550 on 2018-06-27.
//  Copyright © 2018 MCDA5550. All rights reserved.
//

import UIKit

enum RankBy{
    case prominence
    case distance
    
    func description() -> String {
        switch self {
        case .prominence:
            return "Prominence"
        case .distance:
            return "Distance"
        }
    }
}

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var openNowSwitch: UISwitch!
    var switchIsOpen: Bool?
    
    @IBOutlet weak var rankByPicker: UIPickerView!
    
    @IBOutlet weak var rankByLabel: UILabel!
    var rankOptionSelected: String?
    
    @IBOutlet weak var radiusSlider: UISlider!
    var radiusSelected: Float?
    
    var rankByDictionary: [RankBy] = [.prominence, .distance]
    
    var rankSelected: RankBy = .prominence
    
    var filtersObject: [String : Any] = [:]
    
    var delegate: FiltersServiceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rankByPicker.isHidden = true
        
        rankByLabel.text = rankSelected.description()
        
        rankByPicker.dataSource = self
        rankByPicker.delegate = self
        
        rankByLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(togglePickerView))
        gestureRecognizer.numberOfTapsRequired = 2
        rankByLabel.addGestureRecognizer(gestureRecognizer)
        
        radiusSelected = radiusSlider.value
        switchIsOpen = openNowSwitch.isOn
        rankOptionSelected = rankByLabel.text
        
        filtersObject["radius"] = radiusSlider.value
        filtersObject["switchIsOn"] = openNowSwitch.isOn
        filtersObject["rankSelected"] = rankByLabel.text
        filtersObject["filters_changed"] = true
        
    }
    
    @objc func togglePickerView() {
        rankByPicker.isHidden = !rankByPicker.isHidden
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: UIBarButtonItem) {
        //dismiss the modal
//        dismiss(animated: true, completion: nil)
        if delegate != nil {
            delegate?.retrieveFilterParameters(controller: self, filters: filtersObject)
        } else {
            print("delegate is nil")
        }
    }
    
    @IBAction func openNowSelectionChange(_ sender: UISwitch) {
        print("switch is \(sender.isOn)")
        self.filtersObject["switchIsOn"] = sender.isOn
    }
    
    @IBAction func radisuChanged(_ sender: UISlider) {
        print("radius is \(sender.value)")
        self.filtersObject["radius"] = sender.value
    }
    
    
    /*
     // MARK: - Navigation
     
     //In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     let filterViewController: FiltersViewController = segue.destination as! FiltersViewController
     
     filterViewController.delegate = self
     }
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rankByDictionary.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rankByDictionary[row].description()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rankSelected = rankByDictionary[row]
        rankByLabel.text = rankSelected.description()
        self.filtersObject["rankSelected"] = rankByLabel.text
    }
    
    func resetFilters() {
        radiusSlider.value = (radiusSelected as Float?)!
        openNowSwitch.isOn = (switchIsOpen as Bool?)!
        rankByLabel.text = rankOptionSelected as String?
    }
    
}
