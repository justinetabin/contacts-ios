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
    var worker: ContactsWorker
    var input: ListContactsViewModel.Input
    var output: ListContactsViewModel.Output
    private var contacts = [Contact]() 
    
    struct Input {
        var viewDidLoad: Observable<()>
    }
    
    struct Output {
        var displayedContacts: Observable<[[DisplayableContact]]>
        var titleForHeaderInSection: [String]
        var sectionIndexTitles: [String]
    }
    
    struct DisplayableContact {
        var id: String
        var fullname: String
    }
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        input = Input(viewDidLoad: Observable(()))
        output = Output(displayedContacts: Observable([]),
                        titleForHeaderInSection: [],
                        sectionIndexTitles: [])
        
        input.viewDidLoad.observe(on: self) {
            self.worker.fetchContacts { (contacts) in
                self.contacts = contacts
                self.setContacts()
            }
        }
    }
    
    private func setContacts() {
        let contactGroups = self.worker.groupContacts(contacts: self.contacts)
        self.output.displayedContacts.value = contactGroups.map {
            $0.contacts.map {
                DisplayableContact(
                    id: $0._id,
                    fullname: "\($0.firstName) \($0.lastName)"
                )
            }
        }
        self.output.titleForHeaderInSection = contactGroups.map { $0.title }
        self.output.sectionIndexTitles = contactGroups.map { $0.title.first!.uppercased() }
    }
}
