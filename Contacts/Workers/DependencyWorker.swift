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
}

struct DependencyWorker {
    var contactsApi: ContactsStoreProtocol
    
    init(contactsApi: ContactsStoreProtocol) {
        self.contactsApi = contactsApi
    }
}

extension DependencyWorker: WorkerFactory {
    
    func makeContactsWorker() -> ContactsWorker {
        return ContactsWorker(contactsStore: contactsApi)
    }
}

extension DependencyWorker: ViewControllerFactory {
    
    func makeListContacts() -> ListContactsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ListContactsViewController") as! ListContactsViewController
        vc.viewModel = ListContactsViewModel(factory: self)
        vc.factory = self
        return vc
    }
}
