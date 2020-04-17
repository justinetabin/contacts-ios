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
    
    var viewModel: ShowContactViewModelType!
    var factory: ViewControllerFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.input.fetchContact.value = ()
        viewModel.output.presentableError.observe(on: self) { [weak self] (message) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                let vc = weakSelf.factory.makeAlertableError(message: message)
                weakSelf.present(vc, animated: true, completion: nil)
            }
        }
    }
    
}

extension ShowContactViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayableSection = viewModel.output.displayableSections[indexPath.section]
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
        return viewModel.output.numberOfRowsInSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.output.heightForRowInSection(section: indexPath.section, row: indexPath.row))
    }
}
