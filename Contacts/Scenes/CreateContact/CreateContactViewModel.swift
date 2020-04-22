//
//  CreateContactViewModel.swift
//  Contacts
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation

class CreateContactViewModel: ViewModelType {
    
    struct Input {
        var viewDidLoad: Observable<()>
        var didTapSave: Observable<()>
        var didEnterFirstName: Observable<String>
        var didEnterLastName: Observable<String>
        var didEnterEmail: Observable<String>
        var didEnterPhoneNumber: Observable<String>
    }
    
    struct Output {
        var createdContact: Observable<Contact?>
        var presentableError: Observable<String>
        var displayableSections: Observable<[TableSection]>
    }
    
    var input: Input = Input(viewDidLoad: Observable(()),
                             didTapSave: Observable(()),
                             didEnterFirstName: Observable(""),
                             didEnterLastName: Observable(""),
                             didEnterEmail: Observable(""),
                             didEnterPhoneNumber: Observable(""))
    var output: Output = Output(createdContact: Observable(nil),
                                presentableError: Observable(""),
                                displayableSections: Observable([]))
    var worker: ContactsWorker
    
    init(factory: WorkerFactory) {
        worker = factory.makeContactsWorker()
        
        input.viewDidLoad.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            self.output.displayableSections.value = [.heading, .detail]
        }
        
        input.didTapSave.observe(on: self) { [weak self] (_) in
            guard let self = self else { return }
            let contact = Contact(_id: "",
                                  firstName: self.input.didEnterFirstName.value,
                                  lastName: self.input.didEnterLastName.value,
                                  email: self.input.didEnterEmail.value,
                                  phoneNumber: self.input.didEnterPhoneNumber.value,
                                  createdAt: "",
                                  updatedAt: "")
            self.worker.createContact(contactToCreate: contact) { (contact) in
                self.output.createdContact.value = contact
                if contact == nil {
                    self.output.presentableError.value = "Contact not created"
                }
            }
        }
    }
    
    deinit {
        
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
