//
//  ShowContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/16/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class ShowContactViewModel: ViewModelType {

    struct Input {
        var viewDidLoad: Observable<()>
    }
    
    struct Output {
        var presentableError: Observable<String>
        var displayableSections: Observable<[TableSection]>
        var displayableContact: DisplayContact
    }
    
    struct Route {
        var contactId: String
    }
    
    var input: Input = Input(viewDidLoad: Observable(()))
    var output: Output = Output(presentableError: Observable(""),
                                displayableSections: Observable([]),
                                displayableContact: DisplayContact(avatarUrl: Observable(""),
                                                                   fullname: Observable(""),
                                                                   email: Observable(""),
                                                                   phoneNumber: Observable("")))
    var route: Route = Route(contactId: "")
    var worker: ContactsWorker
    
    init(contactId: String, factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        route.contactId = contactId
        
        input.viewDidLoad.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.worker.getContact(contactId: contactId) { (contact) in
                if let contact = contact {
                    self.setDisplayableContact(contact: contact)
                    self.output.displayableSections.value = [.heading, .detail]
                } else {
                    self.output.presentableError.value = "Contact not found"
                }
            }
        }
        
        worker.observers.didUpdateContact.observe(on: self) { [weak self] (contact) in
            guard let self = self else { return }
            if let contact = contact {
                self.setDisplayableContact(contact: contact)
            }
        }
    }
    
    deinit {
        
    }
    
    private func setDisplayableContact(contact: Contact) {
        self.output.displayableContact.fullname.value = "\(contact.firstName) \(contact.lastName)"
        self.output.displayableContact.email.value = contact.email
        self.output.displayableContact.phoneNumber.value = contact.phoneNumber
    }
}

extension ShowContactViewModel {
    
    struct DisplayContact {
        var avatarUrl: Observable<String>
        var fullname: Observable<String>
        var email: Observable<String>
        var phoneNumber: Observable<String>
    }
    
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
