//
//  ListContactsViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/11/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class ListContactsViewModel {
    
    struct Input {
        var viewDidLoad: Observable<()>
    }
    
    struct Output {
        var displayableContacts: Observable<[[DisplayContact]]>
        var titleForHeader: Observable<[String]>
        var sectionIndexTitles: Observable<[String]>
    }

    struct DisplayContact {
        var id: String
        var fullname: String
    }
    
    var input: Input = Input(viewDidLoad: Observable(()))
    var output: Output = Output(displayableContacts: Observable([]),
                                titleForHeader: Observable([]),
                                sectionIndexTitles: Observable([]))
    var worker: ContactsWorker
    
    private var contacts = [Contact]()
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.viewDidLoad.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.worker.fetchContacts { (contacts) in
                self.contacts = contacts
                self.setDisplayableContact()
            }
        }
    }
    
    private func setDisplayableContact() {
        let groupedContacts = worker.groupContacts(contacts: contacts)
        self.output.displayableContacts.value = groupedContacts.map {
            $0.contacts.map {
                DisplayContact(id: $0._id, fullname: "\($0.firstName) \($0.lastName)")
            }
        }
        self.output.titleForHeader.value = groupedContacts.map { $0.title }
        self.output.sectionIndexTitles.value = groupedContacts.map { $0.title.first!.uppercased() }
    }
}
