//
//  ContactDetailViewController.swift
//  CROSA
//
//  Created by Jimmy Pham on 5/27/18.
//  Copyright © 2018 Jimmy Pham. All rights reserved.
//

import UIKit
import SVProgressHUD
import PopupDialog
import SwiftyPickerPopover
import Alamofire
import MessageUI

class ContactDetailViewController: BaseViewController {
    
    //Custom button text
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
        NSAttributedStringKey.foregroundColor : UIColor.blue,
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    var picker: DateTimePicker?
    var timePickertype: Int!
    var callID: String!
    private var historyCalls: [HistoryCall]!
    @IBOutlet weak var wrapperView: UIView!
    
    private var contact: Contact {
        didSet {
            updateView()
        }
    }
    @IBOutlet weak var callState: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    init(withContact contact: Contact) {
        self.contact = contact
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Thong Tin L1
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var callBtn: UIButton!
    
    //Thong Tin L3 L6
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var teacherLbl: UILabel!
    @IBOutlet weak var noteTv: UITextView!
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var checkBoxView2: UIView!
    @IBOutlet weak var checkBoxView3: UIView!
    
    @IBOutlet weak var teacherTestLbl: UILabel!
    @IBOutlet weak var noteTestLbl: UILabel!
    
    @IBOutlet weak var dateTestScoreLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    @IBOutlet weak var dateInterviewScoreLbl: UILabel!
    @IBOutlet weak var scoreIntervireLbl: UILabel!
    @IBOutlet weak var levelInterviewLbl: UILabel!
    
    //Thong Tin L7 L8
    @IBOutlet weak var SBLbl: UILabel!
    @IBOutlet weak var SBLink: UIButton!
    
    @IBOutlet weak var callScheduleLbl: UILabel!
    @IBOutlet weak var levelCallLbl: UILabel!
    @IBOutlet weak var contentTv: UITextView!
    @IBOutlet weak var tableViewHistory: UITableView!
    
    private func showDetail(historyCalls: HistoryCall) {
        let record = RecordListViewController(record: historyCalls)
        let popupDialog = PopupDialog(viewController: record,
                                      buttonAlignment: .horizontal,
                                      transitionStyle: .fadeIn,
                                      preferredWidth: UIScreen.main.bounds.width - 16,
                                      gestureDismissal: true)
        present(popupDialog, animated: true, completion: nil)
    }
    
    @IBAction func didTapCall(_ sender: UIButton) {
        if isCalling {
            // End call
            isCalling = false
            StringeeManager.shared.endCall()
            self.callState.text = "Kết thúc cuộc gọi"
            return
        }
        
        guard let phone = phoneTf.text, phone != "" else { return }
        
        isCalling = true
        StringeeManager.shared.call(number: phone, calling: {
            self.callState.text = "Đang gọi..."
        }, ringing: {
            self.callState.text = "Đang đổ chuông..."
        }, answered: {
            self.callState.text = "Đang kết nối"
        }, busy: {
            self.callState.text = "Số máy bận"
            self.isCalling = false
        }) {
            self.callState.text = "Kết thúc cuộc gọi"
            self.isCalling = false
            self.callID = StringeeManager.shared.callID
        }
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private var isCalling: Bool = false {
        didSet {
            callBtn.setTitle(isCalling ? "Huỷ" : "Gọi", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        levelTf.keyboardType = UIKeyboardType.numberPad
        self.setEndEditing()
        remakeWrapperView(wrapperView)
        updateView()
        setView()
        historyCalls = []
        
        let attributeString = NSMutableAttributedString(string: "https://www.google.com/",
                                                        attributes: yourAttributes)
        SBLink.setAttributedTitle(attributeString, for: .normal)
        
        let titleTextAttributesNormal = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        
        tableViewHistory.dataSource = self
        tableViewHistory.delegate = self
        
        tableViewHistory.registerCell(type: RecordCell.self)
        tableViewHistory.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTable()
    }
    
    func updateTable() {
        SVProgressHUD.show()
        contact.getRecord(success: { (historyCall) in
            SVProgressHUD.dismiss()
            if historyCall.count == 0 {
                //                self.errorServer(content: "Không có dữ liệu ghi âm cuộc gọi!")
            } else {
                self.historyCalls = historyCall
                self.tableViewHistory.reloadData()
            }
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        
    }
    
    private func updateView() {
        nameTf.text = contact.name
        phoneTf.text = contact.phone
        emailTf.text = contact.email
        
    }
    
    private func setView(){
        containerView.isHidden = false
        containerView2.isHidden = true
        
        let squareBox = Checkbox(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        squareBox.tintColor = .black
        squareBox.borderStyle = .square
        squareBox.checkmarkStyle = .square
        squareBox.uncheckedBorderColor = .lightGray
        squareBox.borderWidth = 1
        squareBox.valueChanged = { (value) in
            print("square checkbox value change: \(value)")
        }
        checkBoxView.addSubview(squareBox)
        
        let squareBox2 = Checkbox(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        squareBox2.tintColor = .black
        squareBox2.borderStyle = .square
        squareBox2.checkmarkStyle = .square
        squareBox2.uncheckedBorderColor = .lightGray
        squareBox2.borderWidth = 1
        squareBox2.valueChanged = { (value) in
            print("square 2 checkbox value change: \(value)")
        }
        checkBoxView2.addSubview(squareBox2)
        
        let squareBox3 = Checkbox(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        squareBox3.tintColor = .black
        squareBox3.borderStyle = .square
        squareBox3.checkmarkStyle = .square
        squareBox3.uncheckedBorderColor = .lightGray
        squareBox3.borderWidth = 1
        squareBox3.valueChanged = { (value) in
            print("square 3 checkbox value change: \(value)")
        }
        checkBoxView3.addSubview(squareBox3)
    }
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        guard let contactName = nameTf.text, contactName != "" else {
            SVProgressHUD.showError(withStatus: "Tên không được để trống!")
            return
        }
        
        guard let contactEmail = emailTf.text, contactEmail != "" else {
            SVProgressHUD.showError(withStatus: "Emal không được để trống!")
            return
        }
        
        SVProgressHUD.show()
        contact.updateContact(id: contact.id.description,
                              name: contactName, email: contactEmail,
                              success: { (json) in
                                SVProgressHUD.dismiss()
                                print(json)
                                self.successServer(content: "Cập nhật thành công")
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }
    
    @IBAction func didChange(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            containerView.isHidden = false
            containerView2.isHidden = true
        case 1:
            containerView.isHidden = true
            containerView2.isHidden = false
        //            updateTable()
        default:
            break;
        }
    }
    
    @IBAction func datePicker(_ sender: UIButton) {
        timePicker(type: 0)
    }
    
    @IBAction func teacherSelect(_ sender: UIButton) {
        
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "value 1":
                    return "ádasd"
                case "value 2":
                    return "ầdfdsfsdf"
                case "value 3":
                    return "sdfsdfsdfsdf"
                default:
                    return s
                }
            }
            return nil
        }
        /// Create StringPickerPopover:
        let p = StringPickerPopover(title: "Chọn giảng viên", choices: ["value 1","value 2","value 3"])
            .setDisplayStringFor(displayStringFor)
            .setFont(UIFont.boldSystemFont(ofSize: 14))
            .setFontColor(.blue)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            .setDoneButton(
                font: UIFont.boldSystemFont(ofSize: 16),
                color: UIColor.blue,
                action: { popover, selectedRow, selectedString in
                    self.teacherLbl.text = selectedString
                    print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
    }
    
    func timePicker(type: Int){
        timePickertype = type
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 30)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.timeInterval = DateTimePicker.MinuteInterval.thirty
        picker.highlightColor = UIColor.orange
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Đặt lịch"
        picker.doneBackgroundColor = UIColor.orange
        picker.locale = Locale(identifier: "vi_VN")

        picker.todayButtonTitle = "Hôm nay"
        picker.is12HourFormat = true
        picker.dateFormat = "YYYY/MM/dd HH:mm:ss"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            let formatter = DateFormatter()
//            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
            formatter.dateFormat = "YYYY/MM/dd HH:mm:ss"

            self.title = formatter.string(from: date)
        }
        picker.delegate = self
        self.picker = picker
    }
    
    @IBAction func selectedSB(_ sender: UIButton) {
    }
    
    @IBAction func didTapOrderSB(_ sender: UIButton) {
        
    }
    
    @IBAction func openHyperlink(_ sender: UIButton) {
        downloadAndSendMail(urlString: "https://www.antennahouse.com/XSLsample/pdf/sample-link_1.pdf")
    }
    
    func downloadAndSendMail(urlString:String){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            print("***documentURL: ",documentsURL)
            let PDF_name : String = "sample-link_1"
            let fileURL = documentsURL.appendingPathComponent(PDF_name)
            print("***fileURL: ",fileURL)
            return (fileURL!,[.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(urlString, to: destination).downloadProgress(closure: { (prog) in
        }).response { response in
            if response.error == nil, let filePath = response.destinationURL?.path {
                print("File Path: ",filePath)
                if( MFMailComposeViewController.canSendMail() ) {
                    print("Can send email.")
                    
                    let mailComposer = MFMailComposeViewController()
                    mailComposer.mailComposeDelegate = self
                    
                    //Set the subject and message of the email
                    mailComposer.setSubject("Have you heard a swift?")
                    mailComposer.setMessageBody("This is what they sound like.", isHTML: false)
                    
                    if let fileData = NSData(contentsOfFile: filePath) {
                        print("File data loaded.")
                        mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "sample-link_1")
                    }
                    self.present(mailComposer, animated: true, completion: nil)
                }else {
                    print("Cannot sent mail")
                }
            }
        }
    }
    
    //    func openUrl(urlStr:String!) {
    //
    //        if let url = NSURL(string:urlStr) {
    //            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    //        }
    //
    //    }
    
    @IBAction func didTapCallSchedule(_ sender: UIButton) {
        timePicker(type: 1)
    }
    
    @IBAction func didTapChooseLevel(_ sender: UIButton) {
        let displayStringFor:((String?)->String?)? = { string in
            if let s = string {
                switch(s){
                case "1":
                    return "1"
                case "2":
                    return "2"
                case "3":
                    return "3"
                default:
                    return s
                }
            }
            return nil
        }
        /// Create StringPickerPopover:
        let p = StringPickerPopover(title: "Level", choices: ["1","2","3"])
            .setDisplayStringFor(displayStringFor)
            .setFont(UIFont.boldSystemFont(ofSize: 14))
            .setFontColor(.blue)
            .setValueChange(action: { _, _, selectedString in
                print("current string: \(selectedString)")
            })
            .setDoneButton(
                font: UIFont.boldSystemFont(ofSize: 16),
                color: UIColor.blue,
                action: { popover, selectedRow, selectedString in
                    self.levelCallLbl.text = selectedString
                    print("done row \(selectedRow) \(selectedString)")
            })
            .setCancelButton(action: {_, _, _ in
                print("cancel") })
        p.appear(originView: sender, baseViewController: self)
        p.disappearAutomatically(after: 3.0, completion: { print("automatically hidden")} )
    }
    
    @IBAction func didTapUpdateCall(_ sender: UIButton) {
        guard let contactName = nameTf.text, contactName != "" else {
            SVProgressHUD.showError(withStatus: "Tên không được để trống!")
            return
        }
        
        guard let contactEmail = emailTf.text, contactEmail != "" else {
            SVProgressHUD.showError(withStatus: "Emal không được để trống!")
            return
        }
        
        
        SVProgressHUD.show()
        contact.updateCall(id: contact.id.description, name: contactName , email: contactEmail, level: levelCallLbl.text!, call_id: callID, callBackTime: callScheduleLbl.text!, comment: contentTv.text,
                              success: { (json) in
                                SVProgressHUD.dismiss()
                                print(json)
                                self.successServer(content: "Cập nhật thành công")
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
//        self.updateTable()
    }
    
    
}

extension ContactDetailViewController:DateTimePickerDelegate{
    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        if (timePickertype == 0){
            dateLbl.text = picker.selectedDateString
        }else{callScheduleLbl.text =  picker.selectedDateString}
        
    }
}

extension ContactDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: RecordCell.self, for: indexPath)
        let historyCall = historyCalls[indexPath.row]
        cell.updateWith(historyCall: historyCall, index: indexPath.row + 1){
            print("tap at index ",indexPath.row)
        }
        return cell
    }
}

extension ContactDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let historyCall = historyCalls[indexPath.row]
        showDetail(historyCalls: historyCall)
        SVProgressHUD.show()
    }
}

extension ContactDetailViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Swift.Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
            controller.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
            controller.dismiss(animated: true, completion: nil)
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
            controller.dismiss(animated: true, completion: nil)
            successServer(content: "Gửi mail thành công")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
            controller.dismiss(animated: true, completion: nil)
            errorServer(content: "Lỗi gửi mail, vui long thử lại!")
        default:
            controller.dismiss(animated: true, completion: nil)
            break
            
        }
    }
}
