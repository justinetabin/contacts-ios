//
//  UpdateContactViewController.swift
//  Contacts
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class UpdateContactViewController: UITableViewController {
    
    var factory: ViewControllerFactory!
    var viewModel: UpdateContactViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
        viewModel.input.setSaveEnable.observe(on: self) { [weak self] (bool) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.navigationItem.rightBarButtonItem?.isEnabled = bool
            }
        }
        
        viewModel.input.didUpdateContact.observe(on: self) { [weak self] (contact) in
            guard let weakSelf = self else { return }
            if contact != nil {
                DispatchQueue.main.async {
                    weakSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.output.presentableError.observe(on: self) { [weak self] (message) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                let vc = weakSelf.factory.makeAlertableError(message: message)
                weakSelf.present(vc, animated: true)
            }
        }
        
        viewModel.input.fetchContact.value = ()
    }
    
    @objc func didTapSave(button: UIBarButtonItem) {
        viewModel.input.didTapSave.value = ()
    }
    
}

extension UpdateContactViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayableSection = viewModel.output.displayableSections[indexPath.section]
        let displayableRow = displayableSection.displayableRows[indexPath.row]
        
        switch displayableRow {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateContactInputAvatarTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case .firstName, .lastName, .email, .phoneNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateContactInputDetailTableViewCell", for: indexPath) as! UpdateContactInputDetailTableViewCell
            cell.selectionStyle = .none
            cell.placeholderLabel.text = displayableRow.placeholder
            
            if displayableRow == .firstName {
                cell.formTextField.observable = viewModel.input.didEnterFirstName
                cell.formTextField.returnKeyType = .next
            }
            
            if displayableRow == .lastName {
                cell.formTextField.observable = viewModel.input.didEnterLastName
                cell.formTextField.returnKeyType = .next
            }
            
            if displayableRow == .email {
                cell.formTextField.observable = viewModel.input.didEnterEmail
                cell.formTextField.returnKeyType = .next
            }
            
            if displayableRow == .phoneNumber {
                cell.formTextField.observable = viewModel.input.didEnterPhoneNumber
                cell.formTextField.returnKeyType = .done
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.numberOfRowsInSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.output.heightForRowInSection(section: indexPath.section, row: indexPath.row))
    }
    
}
