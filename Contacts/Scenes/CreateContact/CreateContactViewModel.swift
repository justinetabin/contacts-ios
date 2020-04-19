//
//  CreateContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

protocol CreateContactViewModelType {
    var input: CreateContactViewModel.Input { get set }
    var output: CreateContactViewModel.Output { get set }
}

class CreateContactViewModel: CreateContactViewModelType {
    
    var input: CreateContactViewModel.Input = Input()
    var output: CreateContactViewModel.Output = Output()
    var worker: ContactsWorker!
    
    struct Input {
        var didTapSave = Observable(())
        var didEnterFirstName = Observable("")
        var didEnterLastName = Observable("")
        var didEnterEmail = Observable("")
        var didEnterPhoneNumber = Observable("")
        var didCreateContact: Observable<Contact?> = Observable(nil)
    }
    
    struct Output {
        var presentableError = Observable("")
        var displayableSections: [TableSection] = [.heading, .detail]
        var numberOfSections: Int { return displayableSections.count }
        func numberOfRowsInSection(section: Int) -> Int { return displayableSections[section].numberOfRows }
        func heightForRowInSection(section: Int, row: Int) -> Double { return displayableSections[section].displayableRows[row].rowHeight }
    }
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.didTapSave.observe(on: self) { (_) in
            let contact = Contact(_id: "",
                                  firstName: self.input.didEnterFirstName.value,
                                  lastName: self.input.didEnterLastName.value,
                                  email: self.input.didEnterEmail.value,
                                  phoneNumber: self.input.didEnterPhoneNumber.value,
                                  createdAt: "",
                                  updatedAt: "")
            self.worker.createContact(contactToCreate: contact) { (contact) in
                self.input.didCreateContact.value = contact
                if contact == nil {
                    self.output.presentableError.value = "Contact not created"
                }
            }
        }
    }
    
}

extension CreateContactViewModel {
    
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
