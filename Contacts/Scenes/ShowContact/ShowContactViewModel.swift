//
//  ShowContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/16/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol ShowContactViewModelType {
    var input: ShowContactViewModel.Input { get set }
    var output: ShowContactViewModel.Output { get set }
    var route: ShowContactViewModel.Route { get set }
}

class ShowContactViewModel: ShowContactViewModelType {
    
    var input: ShowContactViewModel.Input = Input()
    var output: ShowContactViewModel.Output = Output()
    var route: ShowContactViewModel.Route = Route()
    
    var worker: ContactsWorker
    var contact: Contact?

    struct Input {
        var fetchContact = Observable(())
        var reloadData = Observable(())
        var didUpdateContact: Observable<Contact?> = Observable(nil)
    }
    
    struct Output {
        var presentableError = Observable("")
        var displayableSections: [TableSection] = [.heading, .detail]
        var displayableContact = DisplayableContact()
        var numberOfSections: Int { return displayableSections.count }
        func numberOfRowsInSection(section: Int) -> Int { return displayableSections[section].numberOfRows }
        func heightForRowInSection(section: Int, row: Int) -> Double { return displayableSections[section].displayableRows[row].rowHeight }
    }
    
    struct Route {
        var contactId = ""
    }
    
    struct DisplayableContact {
        var avatarUrl = Observable("")
        var fullname = Observable("")
        var email = Observable("")
        var phoneNumber = Observable("")
    }
    
    init(contactId: String, factory: WorkerFactory) {
        route.contactId = contactId
        worker = factory.makeContactsWorker()
        
        input.fetchContact.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.worker.getContact(contactId: contactId) { (contact) in
                self.contact = contact
                self.input.reloadData.value = ()
            }
        }
        
        input.reloadData.observe(on: self) { [unowned self] (_) in
            if let contact = self.contact {
                self.output.displayableContact.fullname.value = "\(contact.firstName) \(contact.lastName)"
                self.output.displayableContact.email.value = contact.email
                self.output.displayableContact.phoneNumber.value = contact.phoneNumber
            } else {
                self.output.presentableError.value = "Contact not found"
            }
        }
        
        input.didUpdateContact.observe(on: self) { [unowned self] (contact) in
            self.contact = contact
            self.input.reloadData.value = ()
        }
    }
    
    deinit {
        input.didUpdateContact.remove(observer: self)
    }
    
}

extension ShowContactViewModel {
    
    enum TableSection: Int, CaseIterable {
        case heading
        case detail
        
        var displayableRows: [TableRow] {
            switch self {
            case .heading:
                return [.avatar]
            case .detail:
                return [.fullname, .email, .phoneNumber]
            }
        }
        
        var numberOfRows: Int {
            switch self {
            case .heading: return 1
            case .detail: return 3
            }
        }
    }
    
    enum TableRow: Int, CaseIterable {
        case avatar
        case fullname
        case email
        case phoneNumber
        
        var placeholder: String {
            switch self {
            case .avatar: return ""
            case .fullname: return "full name"
            case .email: return "email"
            case .phoneNumber: return "mobile"
            }
        }
        
        var rowHeight: Double {
            switch self {
            case .avatar: return 200
            case .fullname, .email, .phoneNumber: return 80
            }
        }
    }
    
}
