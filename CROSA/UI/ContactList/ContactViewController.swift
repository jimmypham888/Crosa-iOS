//
//  ContactViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

class ContactViewController: BaseViewController {
    
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var contactList: UITableView!
    
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var contacts: [Contact] = []
    private var filterContacts: [Contact] = []
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEndEditing()
        remakeWrapperView(wrapperView)
        configContactList(contactList)
        configSearchBar(searchBar)
        loadContact()
    }
    
    private func configContactList(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCell(type: ContactTableViewCell.self)
    }
    
    private func configSearchBar(_ searchBar: UISearchBar) {
        searchBar
            .rx.text
            .orEmpty
            .debounce(0.4, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.filter(keyword: query)
            })
            .disposed(by: disposeBag)
    }
    
    private func filter(keyword: String) {
        guard keyword != "" else {
            filterContacts = contacts
            self.contactList.reloadData()
            return
        }
        filterContacts = contacts.filter { "\($0.name)+\($0.phone)+\($0.email)+L\($0.currentLevel)".contains(keyword) }
        self.contactList.reloadData()
    }
    
    private func loadContact() {
        SVProgressHUD.show()
        Contact.get(id: 1, success: { (contacts) in
            SVProgressHUD.dismiss()
            self.contacts = contacts
            self.filterContacts = contacts
            self.contactList.reloadData()
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }
    
    private func navigateToContactDetail(id: Int) {
        
    }

}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ContactTableViewCell.self, for: indexPath)
        let contact = filterContacts[indexPath.row]
        cell.updateWithContact(contact, index: indexPath.row + 1) { self.navigateToContactDetail(id: contact.id) }
        return cell
    }
}

extension ContactViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
