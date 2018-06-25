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
import SwiftyJSON

class ContactDetailViewController: BaseViewController {
    
    var arrSB:[String] = ["3 tháng","6 tháng","9 tháng","12 tháng"]
    var arrLevel:[String] = ["L1","L2","L3","L4","L5","L6","L7","L8"]
    var timeRangeDictionary:[[String: String]] = [["time": "8:00 - 8:30", "hourID": "1", "halfHourID": "0"],
                                              ["time": "8:30 - 9:00", "hourID": "1", "halfHourID": "1"],
                                              ["time": "9:00 - 9:30", "hourID": "2", "halfHourID": "0"],
                                              ["time": "9:30 - 10:00", "hourID": "2", "halfHourID": "1"],
                                              ["time": "10:00 - 10:30", "hourID": "3", "halfHourID": "0"],
                                              ["time": "10:30 - 11:00", "hourID": "3", "halfHourID": "1"],
                                              ["time": "11:00 - 11:30", "hourID": "4", "halfHourID": "0"],
                                              ["time": "11:30 - 12:00", "hourID": "4", "halfHourID": "1"],
                                              ["time": "12:00 - 12:30", "hourID": "5", "halfHourID": "0"],
                                              ["time": "12:30 - 13:00", "hourID": "5", "halfHourID": "1"],
                                              ["time": "13:00 - 13:30", "hourID": "6", "halfHourID": "0"],
                                              ["time": "13:30 - 14:00", "hourID": "6", "halfHourID": "1"],
                                              ["time": "14:00 - 14:30", "hourID": "7", "halfHourID": "0"],
                                              ["time": "14:30 - 15:00", "hourID": "7", "halfHourID": "1"],
                                              ["time": "15:00 - 15:30", "hourID": "8", "halfHourID": "0"],
                                              ["time": "15:30 - 16:00", "hourID": "8", "halfHourID": "1"],
                                              ["time": "16:00 - 16:30", "hourID": "9", "halfHourID": "0"],
                                              ["time": "16:30 - 17:00", "hourID": "9", "halfHourID": "1"],
                                              ["time": "17:00 - 17:30", "hourID": "10", "halfHourID": "0"],
                                              ["time": "17:30 - 18:00", "hourID": "10", "halfHourID": "1"],
                                              ["time": "18:00 - 18:30", "hourID": "11", "halfHourID": "0"],
                                              ["time": "18:30 - 19:00", "hourID": "11", "halfHourID": "1"],
                                              ["time": "19:00 - 19:30", "hourID": "12", "halfHourID": "0"],
                                              ["time": "19:30 - 20:00", "hourID": "12", "halfHourID": "1"],
                                              ["time": "20:00 - 20:30", "hourID": "13", "halfHourID": "0"],
                                              ["time": "20:30 - 21:00", "hourID": "13", "halfHourID": "1"],
                                              ["time": "21:00 - 21:30", "hourID": "14", "halfHourID": "0"],
                                              ["time": "21:30 - 22:00", "hourID": "14", "halfHourID": "1"]]
    //Custom button text
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
        NSAttributedStringKey.foregroundColor : UIColor.blue,
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    
    var picker: DateTimePicker?
    var pickerViewTimeSchedule: UIPickerView!
    var pickerViewLevel: UIPickerView!
    var pickerViewSB: UIPickerView!
    var datePicker : UIDatePicker!
    
    //info make schedule
    var scheduleTest: String?
    var hourID:Int?
    var halfHourID: Int?
    var teacherType: Int?
    var timePickertype: Int!
    var callID: String!
 
    var canDownload: Bool!
    var downloadLink: String?
    var pickerIndex: Int = 0
    var pickerSB: Int = 0
    var pickerLevel: Int = 0
    var sbType: Int?
    
    //Mark
    var vocabulary:Int?
    var grammar:Int?
    var write:Int?
    var listen:Int?
    
    private var crmTesterInfo: CRMTester!
    private var historyCalls: [HistoryCall]!
    @IBOutlet weak var wrapperView: UIView!
    
    private var contact: Contact
//    {
//        didSet {
//            updateView()
//        }
//    }
    
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
    @IBOutlet weak var interviewDatePicker: UIButton!
    
    //Thong Tin L3 L6
    @IBOutlet weak var setSchedule: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var teacherLbl: UILabel!
    @IBOutlet weak var noteTv: UITextView!
    
    
    @IBOutlet weak var getNavtiveAcc: UIButton!
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
        self.setEndEditing()
        remakeWrapperView(wrapperView)
        updateView()
        updateTable()
    }
    
    func initView(){
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateTable() {
        SVProgressHUD.show()
        
        contact.getNative(id_contact: contact.id.description, success: { (json) in
            print(json)
            if ((Int(json["status"].description)! == 1)){
                self.teacherTestLbl.text = json["data"].arrayValue[0]["native_test_account"].description
                self.noteTestLbl.text = json["data"].arrayValue[0]["password"].description
                self.getNavtiveAcc.isHidden = true
            }
//            self.teacherTestLbl.text = json["data"].arrayValue[0]["native_test_account"].description
//            self.noteTestLbl.text = json["data"].arrayValue[0]["password"].description
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        
//        contact.getMarkCRM(phone: String(contact.phone.dropFirst(2)), success: { (json) in
//            if((Int(json["status"].description)! != 1)){
//                if (json["data"]["markInfo"] != JSON.null){
//                    self.dateInterviewScoreLbl.text = json["data"]["dateInterview"].description
//                    self.scoreIntervireLbl.text = json["data"]["markInfo"]["total_point"].description
//                    self.levelInterviewLbl.text = json["data"]["markInfo"]["level"].description
//                }
//            }
//        }) {
//            SVProgressHUD.dismiss()
//            self.errorServer(content: $0)
//        }
   
        contact.getInfoCRM(phone: String(contact.phone.dropFirst(2)), success: { (json) in
            
//            print(json)
            if (json["data"]["interviewStatus"] != JSON.null){
                if ((Int(json["status"].description)! == 1) || (Int(json["status"].description)! == 0 && Int(json["data"]["interviewStatus"].description)! == 2) ){
                    self.setSchedule.setTitle("Huỷ", for: .normal)
                    var timerange = ""
                    for timeRange in self.timeRangeDictionary{
                        if ((timeRange["hourID"] == json["data"]["hourID"].description)
                            && (timeRange["halfHourID"] == json["data"]["hourHalf"].description)){

                            timerange = (timeRange["time"]?.description)!
                        }
                    }
                    
                    self.dateLbl.text = json["data"]["dateInterview"].description + " " + timerange
                    if (json["data"]["historyStatusChange"]["note"] != JSON.null){
                        self.noteTv.text = json["data"]["historyStatusChange"]["note"].description
                    }
                    
                    
                    
                    
                    
//                    self.dateTestScoreLbl.text = self.dateLbl.text
//                    self.scoreLbl.text = "600"
//                    self.levelLbl.text = "Intermediate 200"
//
//                    self.dateInterviewScoreLbl.text = self.dateLbl.text
//                    self.levelInterviewLbl.text = "Basic 100"
//                    self.scoreIntervireLbl.text = "0"
//
                    
                    
                    
                    
                    
                    
                    
                    self.interviewDatePicker.isEnabled = false
                    self.canDownload = true
                }else if (Int(json["status"].description)! == 0 && Int(json["data"]["interviewStatus"].description)! == 5) {
                    self.setSchedule.setTitle("Đặt", for: .normal)
                    self.dateLbl.text = "--/--"
                    self.interviewDatePicker.isEnabled = true
                    self.canDownload = false
                }
            }else{
                self.interviewDatePicker.isEnabled = true
                self.setSchedule.setTitle("Đặt", for: .normal)
                self.canDownload = false
            }
            
            SVProgressHUD.dismiss()
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        
        contact.getRecord(success: { (historyCall) in
            
            if historyCall.count == 0 {
                //                self.errorServer(content: "Không có dữ liệu ghi âm cuộc gọi!")
            } else {
                self.historyCalls = historyCall
                self.tableViewHistory.reloadData()
//                SVProgressHUD.dismiss()
            }
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
    }
    
    private func updateView() {
        callID = ""
        teacherLbl.text = "VN"
        
        SBLink.isEnabled = false
        nameTf.text = contact.name
        phoneTf.text = contact.phone
        phoneTf.keyboardType = .numberPad
        emailTf.text = contact.email
        
        containerView.isHidden = false
        containerView2.isHidden = true
        pickerViewSB = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerViewLevel = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerViewTimeSchedule = UIPickerView(frame: CGRect(x: 0, y: 150, width: 250, height: 150))
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: 250, height: 150))
        historyCalls = []
        let titleTextAttributesNormal = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        
        tableViewHistory.dataSource = self
        tableViewHistory.delegate = self
        
        tableViewHistory.registerCell(type: RecordCell.self)
        tableViewHistory.separatorStyle = .none
        
    }

    func makeSchedule(){
        
        guard let scheduleTest = scheduleTest, scheduleTest != "" else {
            SVProgressHUD.showError(withStatus: "Hãy chọn ngày!")
            return
        }
        
        guard let studentId = contact.studentId, studentId != "" else {
            SVProgressHUD.showError(withStatus: "Có lỗi xay ra!")
            return
        }
        
        SVProgressHUD.show()
        contact.makeSchedule(phoneDefault: String(contact.phone.dropFirst(2)), studentFullname: contact.name, isVip: 0, tvtsName: AccountAuth.default.username, dateInterview: scheduleTest, hourID: hourID!, hourHalf: halfHourID!, teacherType: 2, note: noteTv.text, studentId: Int(studentId)!, levelTester: 0, success: { (json) in
            SVProgressHUD.dismiss()
            print("makeSchedule \(json)")
            if (json["msg"].description.contains("Schedule Success") ){
                self.successServer(content: "Đặt lịch thành công")
//                self.setSchedule.setTitle("Huỷ", for: .normal)
                self.updateTable()
            }else{
                self.errorServer(content: json["msg"].description)
            }
//            self.successServer(content: "Cập nhật thành công")
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        
    }
    
    func cancelSchedule() {
        let refreshAlert = UIAlertController(title: "Huỷ lịch", message: "Bạn có chắc chắn muốn huỷ lịch?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            SVProgressHUD.show()
            self.contact.cancelSchedule(phone: String(self.contact.phone.dropFirst(2)), success: { (json) in
                SVProgressHUD.dismiss()
                print(json)
              self.successServer(content: "Huỷ lịch thành công")
               self.updateTable()
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapUpdate(_ sender: UIButton) {
        guard let contactName = nameTf.text, contactName != "" else {
            SVProgressHUD.showError(withStatus: "Tên không được để trống!")
            return
        }
        
        guard let contactEmail = emailTf.text, contactEmail != "" else {
            SVProgressHUD.showError(withStatus: "Email không được để trống!")
            return
        }
        
        guard let phoneNumber = phoneTf.text, phoneNumber != "" else {
            SVProgressHUD.showError(withStatus: "Số điện thoại không được để trống!")
            return
        }
        
        SVProgressHUD.show()
        contact.updateContact(id: contact.id.description,
                              name: contactName, email: contactEmail, phone: phoneNumber,
                              success: { (json) in
                                SVProgressHUD.dismiss()
                                print(json)
                                if(Int(json["status"].description) == 1){
                                    self.successServer(content: "Cập nhật thành công")
                                    self.updateTable()
                                }else{
                                    self.errorServer(content: "Cập nhật lỗi")
                                }
                                
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
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        datePicker.frame = CGRect(x: 0, y: 0, width: 250, height: 150)
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.locale = Locale(identifier: "vi_VN")
        pickerViewTimeSchedule.delegate = self
        pickerViewTimeSchedule.dataSource = self
        vc.view.addSubview(datePicker)
        vc.view.addSubview(pickerViewTimeSchedule)
        let editRadiusAlert = UIAlertController(title: "Chọn ngày giờ", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Chọn", style: .default, handler:{ (action: UIAlertAction!) in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dateStringArr = self.datePicker.date.description.components(separatedBy: " ")
            self.scheduleTest = dateStringArr[0]
            self.dateLbl.text = dateStringArr[0] + " " + self.timeRangeDictionary[self.pickerIndex]["time"]!
            self.hourID = Int(self.timeRangeDictionary[self.pickerIndex]["hourID"]!)!
            self.halfHourID = Int(self.timeRangeDictionary[self.pickerIndex]["halfHourID"]!)!
            self.view.endEditing(true)
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            self.pickerIndex = 0
            self.view.endEditing(true)
        }))
        self.present(editRadiusAlert, animated: true)

    }
    
//    @objc func cancelDatePicker(){
//        self.view.endEditing(true)
//    }
    

    
    @IBAction func teacherSelect(_ sender: UIButton) {

//        pickerViewDialog(pickerview: pickerViewNumber)
        
    }
    
    @IBAction func selectedSB(_ sender: UIButton) {
        pickerViewDialog(pickerview: pickerViewSB, type: 0)
    }
    
    @IBAction func didTapOrderSB(_ sender: UIButton) {
        if (canDownload == true){
            guard let sbType = sbType, sbType != 0 else {
                SVProgressHUD.showError(withStatus: "Hãy chọn loại SB!")
                return
            }
            
//            guard let vocabulary = vocabulary, vocabulary != 0 else {
//                SVProgressHUD.showError(withStatus: "Học viên chưa có điểm!")
//                return
//            }
//
//            guard let grammar = grammar, grammar != 0 else {
//                SVProgressHUD.showError(withStatus: "Học viên chưa có điểm!")
//                return
//            }
//
//            guard let write = write, write != 0 else {
//                SVProgressHUD.showError(withStatus: "Học viên chưa có điểm!")
//                return
//            }
//
//            guard let listen = listen, listen != 0 else {
//                SVProgressHUD.showError(withStatus: "Học viên chưa có điểm!")
//                return
//            }
        
        SVProgressHUD.show()
//            contact.getAutoSB(phoneDefault: String(contact.phone.dropFirst(2)), studentFullname: contact.name, isVip: 0, tvtsName: AccountAuth.default.username, tuitionTypeId: 28, studentId: contact.id, typeSB: sbType, vocabulary: vocabulary, grammar: grammar, write: write, listen: listen,  success: { (json) in
                contact.getAutoSB(phoneDefault: String(contact.phone.dropFirst(2)), studentFullname: contact.name, isVip: 0, tvtsName: AccountAuth.default.username, tuitionTypeId: 28, studentId: contact.id, typeSB: sbType, vocabulary: 150, grammar: 150, write: 150, listen: 150,  success: { (json) in
            SVProgressHUD.dismiss()
            print(json)
            self.downloadLink = json["data"]["linkSB"].description
            let attributeString = NSMutableAttributedString(string: self.downloadLink!,
                                                            attributes: self.yourAttributes)
            self.SBLink.setAttributedTitle(attributeString, for: .normal)
            self.SBLink.isEnabled = true
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        }
    }
    
    @IBAction func openHyperlink(_ sender: UIButton) {
        downloadAndSendMail(urlString: self.downloadLink!)
    }
    
    func downloadAndSendMail(urlString:String){
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            print("***documentURL: ",documentsURL)
            let PDF_name : String = "Lộ trình học cho học viên \(self.contact.name)"
            let fileURL = documentsURL.appendingPathComponent(PDF_name)
            print("***fileURL: ",fileURL!)
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
                    mailComposer.setSubject("TOPICA NATIVE - Kết quả bài test và lộ trình học tập của học viên")
                    mailComposer.setMessageBody("Đây là SB 100 nha ahihi!!!", isHTML: false)
                    
                    if let fileData = NSData(contentsOfFile: filePath) {
                        print("File data loaded.")
                        mailComposer.addAttachmentData(fileData as Data, mimeType: "application/pdf", fileName: "Lộ trình học cho học viên \(self.contact.name)")
                    }
                    self.present(mailComposer, animated: true, completion: nil)
                }else {
                    print("Cannot sent mail")
                }
            }
        }
    }
    
    
    @IBAction func didTapCallSchedule(_ sender: UIButton) {
//        timePicker(type: 1)
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: 250, height: 300))
        datePicker?.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.locale = Locale(identifier: "vi_VN")
        vc.view.addSubview(datePicker)
        let editRadiusAlert = UIAlertController(title: "Lựa chọn ngày giờ", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Chọn", style: .default, handler: { (action: UIAlertAction!) in
          
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd/MM/yyyy"
            let dateStringArr = self.datePicker.date.description.dropLast(6).components(separatedBy: " ")
            let time = dateStringArr[1]
            let timeArr = time.components(separatedBy: ":")
            let hour = Int(timeArr[0].description)! + 7
            let callScheduleTxt = dateStringArr[0] + " " + String(hour) + ":" + timeArr[1] + ":" + timeArr[2]
            self.callScheduleLbl.text = callScheduleTxt
//            print("select call schedule \(self.datePicker.date.description)")
            self.view.endEditing(true)
//            print("select call schedule \(self.callScheduleLbl.text)")
        }))
        
        editRadiusAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
           self.view.endEditing(true)
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    @IBAction func didTapChooseLevel(_ sender: UIButton) {
        pickerViewDialog(pickerview: pickerViewLevel, type: 1)
    }
    
    func pickerViewDialog(pickerview: UIPickerView, type: Int) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        pickerview.delegate = self
        pickerview.dataSource = self
        vc.view.addSubview(pickerview)
        let editRadiusAlert = UIAlertController(title: "Lựa chọn", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Chọn", style: .default, handler: { (action: UIAlertAction!) in
            if(type == 0){
                self.SBLbl.text = self.arrSB[self.pickerSB]
                self.sbType = Int(String((self.SBLbl.text?.dropLast(6))!))
            }else{
                self.levelCallLbl.text = self.arrLevel[self.pickerLevel]
            }
//            self.pickerLevel = 0
//            self.pickerSB = 0
            self.view.endEditing(true)
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: { (action: UIAlertAction!) in
            self.pickerIndex = 0
            self.pickerLevel = 0
            self.pickerSB = 0
            self.view.endEditing(true)
        }))
        self.present(editRadiusAlert, animated: true)
    }
    
    @IBAction func didTapUpdateCall(_ sender: UIButton) {
        guard let contactName = nameTf.text, contactName != "" else {
            SVProgressHUD.showError(withStatus: "Tên không được để trống!")
            return
        }
        
        guard let contactEmail = emailTf.text, contactEmail != "" else {
            SVProgressHUD.showError(withStatus: "Email không được để trống!")
            return
        }
        
        guard let level = levelCallLbl.text, level != "" else {
            SVProgressHUD.showError(withStatus: "Trạng thái không được để trống!")
            return
        }
        
        guard let phoneNumber = phoneTf.text, phoneNumber != "" else {
            SVProgressHUD.showError(withStatus: "Số điện thoại không được để trống!")
            return
        }
        
        if(callScheduleLbl.text == "--"){callScheduleLbl.text = ""}
        SVProgressHUD.show()
        if(callID != ""){
            contact.updateCall(id: contact.id.description, name: contactName , email: contactEmail, level: String((level.dropFirst(1))), call_id: callID, callBackTime: callScheduleLbl.text!, comment: contentTv.text, phone: phoneNumber,
                               success: { (json) in
                                SVProgressHUD.dismiss()
                                print(json)
                                if(Int(json["status"].description) == 1){
                                    self.successServer(content: "Cập nhật thành công")
                                    self.updateTable()
                                }
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }else {
            contact.updateCallNoCallId(id: contact.id.description, name: contactName , email: contactEmail, level: String((level.dropFirst(1))), callBackTime: callScheduleLbl.text!, comment: contentTv.text, phone: phoneNumber,
                               success: { (json) in
                                SVProgressHUD.dismiss()
                                print(json)
                                if(Int(json["status"].description) == 1){
                                    self.successServer(content: "Cập nhật thành công")
//                                    self.updateTable()
                                }
            }) {
                SVProgressHUD.dismiss()
                self.errorServer(content: $0)
            }
        }
    }
    
    @IBAction func didTapMakeSchedule(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Đặt"){
            makeSchedule()
        }else if (sender.titleLabel?.text == "Huỷ"){
            cancelSchedule()
        }
    
    }
    
    @IBAction func didTapSendRequestTest(_ sender: UIButton) {
        SVProgressHUD.show()
        contact.bookAccount(id_contact: contact.id.description, success: { (json) in
            SVProgressHUD.dismiss()
            print(json)
            self.teacherTestLbl.text = json["data"].arrayValue[0]["native_test_account"].description
            self.noteTestLbl.text = json["data"].arrayValue[0]["password"].description
            self.getNavtiveAcc.isHidden = true
        }) {
            SVProgressHUD.dismiss()
            self.errorServer(content: $0)
        }
        
    }
    
    
}

//extension ContactDetailViewController:DateTimePickerDelegate{
//    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
//        if (timePickertype == 0){
//            dateLbl.text = picker.selectedDateString
//            scheduleTest = picker.selectedDateString
//        }else{callScheduleLbl.text =  picker.selectedDateString}
//
//    }
//}

extension ContactDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyCalls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: RecordCell.self, for: indexPath)
        let historyCall = historyCalls[indexPath.row]
        cell.updateWith(historyCall: historyCall, index: indexPath.row + 1){
//            print("tap at index ",indexPath.row)
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

extension ContactDetailViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == pickerViewSB){
//            SBLbl.text = arrSB[row]
            pickerSB = row
        }else if(pickerView == pickerViewLevel){
//            levelCallLbl.text = arrLevel[row]
            pickerLevel = row
        }else {
            pickerIndex = row
        }
    }
}

extension ContactDetailViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == pickerViewSB){
            return arrSB.count
        }else if(pickerView == pickerViewLevel){
            return arrLevel.count
        }else {
            return timeRangeDictionary.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if (pickerView == pickerViewSB){
            return arrSB[row]
        }else if(pickerView == pickerViewLevel){
            return arrLevel[row]
        }else {
            return timeRangeDictionary[row]["time"]
        }
    }
    
    
}


