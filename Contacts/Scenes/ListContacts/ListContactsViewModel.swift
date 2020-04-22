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
    
    var contacts = [Contact]()
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.viewDidLoad.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.worker.fetchContacts { (contacts) in
                self.contacts = contacts
                self.setDisplayableContact()
            }
        }
        
        worker.observers.didCreateContact.observe(on: self) { [weak self] (contact) in
            guard let self = self else { return }
            if let contact = contact {
                self.contacts.append(contact)
                // TODO: Do diff, instead of reloading entire table
                self.setDisplayableContact()
            }
        }
        
        worker.observers.didUpdateContact.observe(on: self) { [weak self] (contact) in
            guard let self = self else { return }
            if let contact = contact {
                if let index = self.contacts.firstIndex(where: { $0._id == contact._id }) {
                    self.contacts[index] = contact
                    // TODO: Do diff, instead of reloading entire table
                    self.setDisplayableContact()
                }
            }
        }
    }
    
    deinit {
        worker.observers.remove(observer: self)
    }
    
    private func setDisplayableContact() {
        let groupedContacts = worker.groupContacts(contacts: contacts)
        self.output.titleForHeader.value = groupedContacts.map { $0.title }
        self.output.sectionIndexTitles.value = groupedContacts.map { $0.title.first!.uppercased() }
        self.output.displayableContacts.value = groupedContacts.map {
            $0.contacts.map {
                DisplayContact(id: $0._id, fullname: "\($0.firstName) \($0.lastName)")
            }
        }
    }
}
