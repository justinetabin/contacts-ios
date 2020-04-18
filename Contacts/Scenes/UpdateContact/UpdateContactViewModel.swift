//
//  UpdateContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/17/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol UpdateContactViewModelType {
    var input: UpdateContactViewModel.Input { get set }
    var output: UpdateContactViewModel.Output { get set }
}

class UpdateContactViewModel: UpdateContactViewModelType {
    
    var input: UpdateContactViewModel.Input = Input()
    var output: UpdateContactViewModel.Output = Output()
    var worker: ContactsWorker
    
    struct Input {
        var setSaveEnable = Observable(true)
        var didTapSave = Observable(())
        
        var didEnterFirstName = Observable("")
        var didEnterLastName = Observable("")
        var didEnterEmail = Observable("")
        var didEnterPhoneNumber = Observable("")
        
        var fetchContact = Observable(())
        var didUpdateContact: Observable<Contact?> = Observable(nil)
    }
    
    struct Output {
        var presentableError = Observable("")
        var displayableSections: [TableSection] = [.heading, .detail]
        var numberOfSections: Int { return displayableSections.count }
        func numberOfRowsInSection(section: Int) -> Int { return displayableSections[section].numberOfRows }
        func heightForRowInSection(section: Int, row: Int) -> Double { return displayableSections[section].displayableRows[row].rowHeight }
    }
    
    init(contactId: String, factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.fetchContact.observe(on: self) { (_) in
            self.input.setSaveEnable.value = false
            self.worker.getContact(contactId: contactId) { (contact) in
                if let contact = contact {
                    self.input.didEnterFirstName.value = contact.firstName
                    self.input.didEnterLastName.value = contact.lastName
                    self.input.didEnterEmail.value = contact.email
                    self.input.didEnterPhoneNumber.value = contact.phoneNumber
                    self.input.setSaveEnable.value = true
                } else  {
                    self.output.presentableError.value = "Contact not found"
                }
            }
        }
        
        input.didTapSave.observe(on: self) { (_) in
            self.input.setSaveEnable.value = false
            let contact = Contact(_id: contactId,
                                  firstName: self.input.didEnterFirstName.value,
                                  lastName: self.input.didEnterLastName.value,
                                  email: self.input.didEnterEmail.value,
                                  phoneNumber: self.input.didEnterPhoneNumber.value,
                                  createdAt: "",
                                  updatedAt: "")
            self.worker.updateContact(contactToUpdate: contact) { (contact) in
                if let contact = contact {
                    self.input.didUpdateContact.value = contact
                } else {
                    self.output.presentableError.value = "Contact not updated"
                }
                self.input.setSaveEnable.value = true
            }
        }
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
