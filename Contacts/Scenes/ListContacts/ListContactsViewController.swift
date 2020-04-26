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
    var viewModel: ListContactsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        refreshControl?.beginRefreshing()
        
        tableView.sectionIndexColor = UIColor.systemGray3
        tableView.separatorStyle = .none
        if let refreshControl = refreshControl {
            tableView.contentOffset = CGPoint(x: 0, y: -(refreshControl.frame.height))
        }
        
        viewModel.output.displayableContacts.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
        
        viewModel.input.viewDidLoad.value = ()
    }
    
    @objc func didPullToRefresh() {
        viewModel.input.viewDidLoad.value = ()
    }
    
    @objc func didTapAdd() {
        let createContact = factory.makeCreateContact()
        show(createContact, sender: nil)
    }
    
}

extension ListContactsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListContactsTableViewCell", for: indexPath) as! ListContactsTableViewCell
        let displayableContact = viewModel.output.displayableContacts.value[indexPath.section][indexPath.row]
        cell.fullnameLabel.text = displayableContact.fullname
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.displayableContacts.value[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.displayableContacts.value.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.output.titleForHeader.value[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.output.sectionIndexTitles.value
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let displayedContact = viewModel.output.displayableContacts.value[indexPath.section][indexPath.row]
        let showContact = factory.makeShowContact(contactId: displayedContact.id)
        show(showContact, sender: nil)
    }
}
