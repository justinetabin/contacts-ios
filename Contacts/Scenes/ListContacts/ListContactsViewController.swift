//
//  ListContactsViewController.swift
//  Contacts
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

class ListContactsViewController: UITableViewController {
    
    var factory: ViewControllerFactory!
    var viewModel: ListContactsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        tableView.sectionIndexColor = UIColor.systemGray3
        
        viewModel.input.reloadData.observe(on: self) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.input.fetchContacts.value = ()
    }
    
    @objc func didTapAdd() {
        let createContact = factory.makeCreateContact()
        createContact.viewModel.input.didCreateContact = viewModel.input.didCreateContact
        show(createContact, sender: nil)
    }
    
}

extension ListContactsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListContactsTableViewCell", for: indexPath) as! ListContactsTableViewCell
        let displayableContact = viewModel.output.displayedContacts[indexPath.section][indexPath.row]
        cell.fullnameLabel.text = displayableContact.fullname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.numberOfRowsInSection[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.output.titleForHeaderInSection[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.output.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayedContact = viewModel.output.displayedContacts[indexPath.section][indexPath.row]
        let showContact = factory.makeShowContact(contactId: displayedContact.id)
        show(showContact, sender: nil)
    }
}