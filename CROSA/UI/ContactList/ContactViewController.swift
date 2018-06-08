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
    @IBOutlet weak var viewTitle: UILabel!
    @IBOutlet weak var contactAmount: UILabel!
    var refreshControl: UIRefreshControl!
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var contacts: [Contact] = []
    private var filterContacts: [Contact] = []
    
    private let disposeBag = DisposeBag()
    
    
    let contactId: Int
    let type: Int
    init(contactId: Int, type: Int) {
        self.contactId = contactId
        self.type = type
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEndEditing()
        remakeWrapperView(wrapperView)
        configContactList(contactList)
        configSearchBar(searchBar)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContact()
    }
    
    private func configContactList(_ tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.registerCell(type: ContactTableViewCell.self)
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Kéo để tải lại")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: Any) {
        //  your code to refresh tableView
        loadContact()
        contactList.reloadData()
        refreshControl.endRefreshing()
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
        if (type == 0){
            Contact.getPending(id: contactId.description, level: "8", success: { (contacts) in
                self.getDataToTable(contacts: contacts)
                self.viewTitle.text = "Danh sách phải gọi"
                
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }else if (type == 1){
            Contact.getStock(id: contactId.description, success: { (contacts) in
                self.getDataToTable(contacts: contacts)
                self.viewTitle.text = "Danh sách tồn"
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }else{
            Contact.get(id: contactId, success: { (contacts) in
                self.getDataToTable(contacts: contacts)
                self.viewTitle.text = "Tất cả"
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }
        
    }
    
    private func getDataToTable(contacts :[Contact]){
        SVProgressHUD.dismiss()
        self.contacts = contacts
        self.filterContacts = contacts
        self.contactList.reloadData()
        self.contactAmount.text = contacts.count.description
    }
    
    private func navigateContactDetail(contact: Contact) {
        navigationController?.pushViewController(ContactDetailViewController(withContact: contact), animated: true)
    }

}

extension ContactViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ContactTableViewCell.self, for: indexPath)
        let contact = filterContacts[indexPath.row]
        cell.updateWithContact(contact, index: indexPath.row + 1) { self.navigateContactDetail(contact: contact) }
        return cell
    }
}

extension ContactViewController: UITableViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        dismissKeyboard()
    }
}
