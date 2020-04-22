//
//  UpdateContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class UpdateContactViewModel: ViewModelType {
    
    struct Input {
        var viewDidLoad: Observable<()>
        var didTapSave: Observable<()>
        var didEnterFirstName: Observable<String>
        var didEnterLastName: Observable<String>
        var didEnterEmail: Observable<String>
        var didEnterPhoneNumber: Observable<String>
    }
    
    struct Output {
        var saveEnable: Observable<Bool>
        var presentableError: Observable<String>
        var updatedContact: Observable<Contact?>
        var displayableSections: Observable<[TableSection]>
    }
    
    var input: Input = Input(viewDidLoad: Observable(()),
                             didTapSave: Observable(()),
                             didEnterFirstName: Observable(""),
                             didEnterLastName: Observable(""),
                             didEnterEmail: Observable(""),
                             didEnterPhoneNumber: Observable(""))
    var output: Output = Output(saveEnable: Observable(false),
                                presentableError: Observable(""),
                                updatedContact: Observable(nil),
                                displayableSections: Observable([]))
    var worker: ContactsWorker
    
    init(contactId: String, factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.viewDidLoad.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.output.saveEnable.value = false
            self.worker.getContact(contactId: contactId) { (contact) in
                if let contact = contact {
                    self.input.didEnterFirstName.value = contact.firstName
                    self.input.didEnterLastName.value = contact.lastName
                    self.input.didEnterEmail.value = contact.email
                    self.input.didEnterPhoneNumber.value = contact.phoneNumber
                    self.output.saveEnable.value = true
                    self.output.displayableSections.value = [.heading, .detail]
                } else {
                    self.output.presentableError.value = "Contact not found"
                }
            }
        }
        
        input.didTapSave.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.output.saveEnable.value = false
            let contact = Contact(_id: contactId,
                                  firstName: self.input.didEnterFirstName.value,
                                  lastName: self.input.didEnterLastName.value,
                                  email: self.input.didEnterEmail.value,
                                  phoneNumber: self.input.didEnterPhoneNumber.value,
                                  createdAt: "",
                                  updatedAt: "")
            self.worker.updateContact(contactToUpdate: contact) { (contact) in
                self.output.saveEnable.value = true
                if let contact = contact {
                    self.output.updatedContact.value = contact
                } else {
                    self.output.presentableError.value = "Contact not updated"
                }
            }
        }
    }
    
    deinit {
        
    }
}

extension UpdateContactViewModel {
    
    enum TableSection: Int, CaseIterable {
        case heading
        case detail
        
        var displayableRows: [TableRow] {
            switch self {
            case .heading:
                return [.avatar]
            case .detail:
                return [.firstName, .lastName, .email, .phoneNumber]
            }
        }
        
        var numberOfRows: Int {
            switch self {
            case .heading: return 1
            case .detail: return 4
            }
        }
    }
    
    enum TableRow: Int, CaseIterable {
        case avatar
        case firstName
        case lastName
        case email
        case phoneNumber
        
        var placeholder: String {
            switch self {
            case .avatar: return ""
            case .firstName: return "First Name"
            case .lastName: return "Last Name"
            case .email: return "email"
            case .phoneNumber: return "mobile"
            }
        }
        
        var rowHeight: Double {
            switch self {
            case .avatar: return 200
            case .firstName, .lastName, .email, .phoneNumber: return 80
            }
        }
    }
}
