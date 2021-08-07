//
//  ViewController.swift
//  HorizontalOptionSelector
//
//  Created by Rahul K Rajan on 07/08/21.
//

import UIKit

class GuestNumberDataModel {
    internal init(guestNumber: Int? = nil, isSelected: Bool = false) {
        self.guestNumber = guestNumber
        self.isSelected = isSelected
    }
    
    var guestNumber: Int?
    var isSelected = false
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let guestNumbers = [GuestNumberDataModel(guestNumber: 1), GuestNumberDataModel(guestNumber: 2, isSelected: true), GuestNumberDataModel(guestNumber: 3), GuestNumberDataModel(guestNumber: 4), GuestNumberDataModel(guestNumber: 5)]
    var selectedGuestNumber = 1
    var selectedGuestNumberData: GuestNumberDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
    }

    fileprivate func selectGuestNumberBasedOnUserClick() {
        /// Select the guest based on user click
        self.selectedGuestNumberData = self.guestNumbers[self.selectedGuestNumber]
        print(self.selectedGuestNumberData?.guestNumber ?? 1) /// Pass this data to API
        self.selectedGuestNumberData?.isSelected = true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestCell", for: indexPath) as! GuestCell
        cell.guestNumbers = guestNumbers
        cell.leftRightArrowAction = { index in
            switch index {
            case +1:
                if self.selectedGuestNumber != 4 {
                    self.selectedGuestNumber += 1
                }
            default:
                if self.selectedGuestNumber != 0 {
                    self.selectedGuestNumber -= 1
                }
            }
            /// To unselect all guest
            _ = self.guestNumbers.map { (guestNumberDataModel) -> GuestNumberDataModel in
                guestNumberDataModel.isSelected = false
                return guestNumberDataModel
            }
            
            self.selectGuestNumberBasedOnUserClick()
            cell.optionsCollectionView.reloadData()
        }
        return cell
    }
}

class GuestCell: UITableViewCell {
    @IBOutlet weak var leftArrowButton: UIButton!
    @IBOutlet weak var rightArrowButton: UIButton!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    var guestNumbers: [GuestNumberDataModel]?
    
    var leftRightArrowAction: ((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        optionsCollectionView.dataSource = self
    }

    @IBAction func rightLeftArrowAction(_ sender: UIButton) {
        leftRightArrowAction?((sender.tag == 0) ? -1 : +1)
    }
}

extension GuestCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return guestNumbers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuestNumberCell", for: indexPath) as! GuestNumberCell
        let guestNumberData = guestNumbers?[indexPath.item]
        cell.titleLabel.text = "\(guestNumberData?.guestNumber ?? 0)"
        cell.titleLabel.textColor = (guestNumberData?.isSelected ?? false) ? .orange : .black
        return cell
    }
}

class GuestNumberCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
