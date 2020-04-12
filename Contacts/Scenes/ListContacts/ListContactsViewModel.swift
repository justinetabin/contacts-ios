//
//  ListContactsViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ListContactsViewModelType {
    var input: ListContactsViewModel.Input { get set }
    var output: ListContactsViewModel.Output { get set }
}

class ListContactsViewModel: ListContactsViewModelType {
    
    var input: ListContactsViewModel.Input = Input()
    var output: ListContactsViewModel.Output = Output()
    var worker: ContactsWorker
    
    struct Input {
        var fetchContacts = Observable(())
        var reloadData = Observable(())
    }
    
    struct Output {
        var displayedContacts: [[DisplayableContact]] = []
        var numberOfSections: Int = 0
        var numberOfRowsInSection: [Int] = []
        var titleForHeaderInSection: [String] = []
        var sectionIndexTitles: [String] = []
    }
    
    struct DisplayableContact {
        var fullname: String
    }
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.fetchContacts.observe(on: self) { (_) in
            self.worker.fetchContacts { (contacts) in
                let contactGroups = self.worker.groupContacts(contacts: contacts)
                self.output.numberOfSections = contactGroups.count
                self.output.numberOfRowsInSection = contactGroups.map { $0.contacts.count }
                self.output.displayedContacts = contactGroups.map {
                    $0.contacts.map { DisplayableContact(fullname: "\($0.firstName) \($0.lastName)") }
                }
                self.output.titleForHeaderInSection = contactGroups.map { $0.title }
                self.output.sectionIndexTitles = contactGroups.map { $0.title.first!.uppercased() }
                self.input.reloadData.value = ()
            }
        }
    }
}
