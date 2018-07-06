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

struct FilterOptions {
    var switchIsOn: Bool?
    var radiusSelected: Float?
    var rankOption: String?
    var isChanged: Bool?
}

class FiltersViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var openNowSwitch: UISwitch!
    var switchIsOpen: Bool?
    
    @IBOutlet weak var rankByPicker: UIPickerView!
    
    @IBOutlet weak var rankByLabel: UILabel!
    var rankOptionSelected: String?
    
    @IBOutlet weak var radiusSlider: UISlider!
    var radiusSelected: Float?
    
    var filtersChanged: Bool? = false
    
    var rankByDictionary: [RankBy] = [.prominence, .distance]
    
    var rankSelected: RankBy = .prominence
    
    var filtersObject: FilterOptions?
    
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
        
        filtersObject = FilterOptions(switchIsOn: switchIsOpen, radiusSelected: radiusSelected, rankOption: rankOptionSelected, isChanged: filtersChanged)
        
    }
    
    @objc func togglePickerView() {
        rankByPicker.isHidden = !rankByPicker.isHidden
    }
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonAction(_ sender: UIBarButtonItem) {
        // dismiss the modal
        if delegate != nil {
            filtersChanged = true
            filtersObject?.isChanged = filtersChanged
            delegate?.retrieveFilterParameters(controller: self, filters: filtersObject)
        } else {
            print("delegate is nil")
        }
    }
    
    @IBAction func openNowSelectionChange(_ sender: UISwitch) {
        print("switch is \(sender.isOn)")
        filtersObject?.switchIsOn = sender.isOn
    }
    
    @IBAction func radiusChanged(_ sender: UISlider) {
        print("radius is \(sender.value)")
        filtersObject?.radiusSelected = sender.value
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        resetFilters()
        delegate?.retrieveFilterParameters(controller: self, filters: filtersObject)
    }
    
    
    /*
     // MARK: - Navigation
     */
    //In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "applyFilters" {
//            let searchViewController: SearchViewController = segue.destination as! SearchViewController
//            searchViewController.delegate = self
//        }
//    }
    
    // MARK: - Picker View Methods
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
        filtersObject?.rankOption = rankByLabel.text
    }
    
    // MARK: - Reset to default settings
    func resetFilters() {
        radiusSlider.value = (radiusSelected as Float?)!
        openNowSwitch.isOn = (switchIsOpen as Bool?)!
        rankByLabel.text = rankOptionSelected as String?
        filtersChanged = false
        rankByPicker.isHidden = false
        
        filtersObject = FilterOptions(switchIsOn: switchIsOpen, radiusSelected: radiusSelected, rankOption: rankOptionSelected, isChanged: filtersChanged)
        delegate?.retrieveFilterParameters(controller: self, filters: filtersObject)
    }
    
}


