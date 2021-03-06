//
//  ShowContactViewController.swift
//  Contacts
//
//  Created by Justine Tabin on 4/16/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ShowContactViewController: UITableViewController {
    
    var factory: ViewControllerFactory!
    var viewModel: ShowContactViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit))
        
        viewModel.output.displayableSections.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.output.presentableError.observe(on: self) { [weak self] (message) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let vc = self.factory.makeAlertableError(message: message)
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        viewModel.input.viewDidLoad.value = ()
    }
    
    @objc func didTapEdit() {
        let vc = factory.makeUpdateContact(contactId: viewModel.route.contactId)
        show(vc, sender: nil)
    }
    
}

extension ShowContactViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayableSection = viewModel.output.displayableSections.value[indexPath.section]
        let displayableRow = displayableSection.displayableRows[indexPath.row]
        
        switch displayableRow {
        case .avatar:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowContactAvatarTableViewCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
            
        case .fullname, .email, .phoneNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShowContactDetailTableViewCell", for: indexPath) as! ShowContactDetailTableViewCell
            cell.selectionStyle = .none
            cell.placeholderLabel.text = displayableRow.placeholder
            
            if displayableRow == .fullname {
                cell.formTextField.observable = viewModel.output.displayableContact.fullname
                cell.formTextField.returnKeyType = .next
            }
            
            if displayableRow == .email {
                cell.formTextField.observable = viewModel.output.displayableContact.email
                cell.formTextField.returnKeyType = .next
            }
            
            if displayableRow == .phoneNumber {
                cell.formTextField.observable = viewModel.output.displayableContact.phoneNumber
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
