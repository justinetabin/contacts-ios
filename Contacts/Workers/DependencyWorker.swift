//
//  DependencyWorker.swift
//  Contacts
//
//  Created by Justine Tabin on 4/12/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import UIKit

protocol WorkerFactory {
    func makeContactsWorker() -> ContactsWorker
}

protocol ViewControllerFactory {
    func makeListContacts() -> ListContactsViewController
    func makeCreateContact() -> CreateContactViewController
    func makeShowContact(contactId: String) -> ShowContactViewController
    func makeUpdateContact(contactId: String) -> UpdateContactViewController
    func makeAlertableError(message: String) -> UIAlertController
}

class DependencyWorker: WorkerFactory, ViewControllerFactory {
    
    var contactsApi: ContactsStoreProtocol
    var contactsWorker: ContactsWorker
    
    init(contactsApi: ContactsStoreProtocol) {
        self.contactsApi = contactsApi
        self.contactsWorker = ContactsWorker(contactsStore: contactsApi)
    }
    
    /*
     Worker Factory Protocol
     */
    func makeContactsWorker() -> ContactsWorker {
        return contactsWorker
    }
    
    /*
     ViewController Factory protocols
     */
    func makeListContacts() -> ListContactsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListContactsViewController") as! ListContactsViewController
        vc.viewModel = ListContactsViewModel(factory: self)
        vc.factory = self
        return vc
    }
    
    func makeCreateContact() -> CreateContactViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateContactViewController") as! CreateContactViewController
        vc.viewModel = CreateContactViewModel(factory: self)
        vc.factory = self
        return vc
    }
    
    func makeShowContact(contactId: String) -> ShowContactViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ShowContactViewController") as! ShowContactViewController
        vc.viewModel = ShowContactViewModel(contactId: contactId, factory: self)
        vc.factory = self
        return vc
    }
    
    func makeUpdateContact(contactId: String) -> UpdateContactViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UpdateContactViewController") as! UpdateContactViewController
        vc.viewModel = UpdateContactViewModel(contactId: contactId, factory: self)
        vc.factory = self
        return vc
    }
    
    func makeAlertableError(message: String) -> UIAlertController {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        return vc
    }
}
