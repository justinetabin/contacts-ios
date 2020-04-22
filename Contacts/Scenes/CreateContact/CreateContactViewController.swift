//
//  CreateContactViewController.swift
//  Contacts
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class CreateContactViewController: UITableViewController {
    
    var factory: ViewControllerFactory!
    var viewModel: CreateContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.keyboardDismissMode = .onDrag
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(didTapSave))
        
        viewModel.input.didTapSave.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        viewModel.output.createdContact.observe(on: self) { [weak self] (contact) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                if contact != nil {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        viewModel.output.presentableError.observe(on: self) { [weak self] (message) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let alertVC = self.factory.makeAlertableError(message: message)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
        
        viewModel.input.viewDidLoad.value = ()
    }
    
    @objc func didTapSave() {
        viewModel.input.didTapSave.value = ()
    }
}

extension CreateContactViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayableSection = viewModel.output.displayableSections.value[indexPath.section]
        let displayableRow = displayableSection.displayableRows[indexPath.row]
        
        switch displayableRow {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateContactInputAvatarTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case .firstName, .lastName, .email, .phoneNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateContactInputDetailTableViewCell", for: indexPath) as! CreateContactInputDetailTableViewCell
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
        return viewModel.output.displayableSections.value[section].numberOfRows
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.displayableSections.value.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.output.displayableSections.value[indexPath.section].displayableRows[indexPath.row].rowHeight)
    }
}
