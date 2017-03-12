//
//  AddSchedule.swift
//  EasyLife
//
//  Created by 王昊泽 on 17/3/10.
//  Copyright © 2017年 Haoze Wang. All rights reserved.
//

import UIKit
import CoreData
class AddSchedule: UIViewController,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
    
    @IBOutlet weak var SetRemTime: UIButton!
    @IBOutlet weak var RemMinute: UILabel!
    @IBOutlet weak var Remhours: UILabel!
    @IBOutlet weak var RemMonth: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var UITextLabel: UITextField!
    @IBOutlet weak var UIPickerView: UIView!
    @IBOutlet weak var SetTime: UIButton!
    @IBOutlet weak var Minute: UILabel!
    @IBOutlet weak var Month: UILabel!
    @IBOutlet weak var YearPickerView: UIPickerView!
    @IBOutlet weak var ScheduleLabel: UILabel!
    
    @IBOutlet weak var show_hour: UILabel!
    @IBOutlet weak var show_minute: UILabel!
    @IBOutlet weak var TextField: UITextView!
    var flag = 1
    var changeflag = 1
    var day : [String] = []
    var date : [Date] = []
    var record_date_begin : Date!
    var record_date_end : Date!
    var hour: [String] = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var minutes: [String] = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"]
    override func viewDidLoad() {
        super.viewDidLoad()
        TextField.delegate = self
        YearPickerView.delegate = self
        YearPickerView.dataSource = self
        UITextLabel.delegate = self
        TextField.text = "Please enter the description of the schedule"
        TextField.textColor = UIColor.lightGray
        SetTime.tintColor = UIColor.black
        Month.text = "Today"
        hours.text = "00:"
        Minute.text = "00"
        show_hour.text = "00:"
        show_minute.text = "00"
        setTextField()
        creatday()
        let myGesture = UITapGestureRecognizer(target: self, action:#selector(self.tappedAwayFunction(sender:)) )
        self.view.addGestureRecognizer(myGesture)
        // Do any additional setup after loading the view.
    }
    
    func tappedAwayFunction(sender: UITapGestureRecognizer){
        TextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        TextField.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTextField(){
        TextField.layer.backgroundColor = UIColor.white.cgColor
        TextField.layer.borderColor = UIColor.gray.cgColor
        TextField.layer.borderWidth = 0.0
        TextField.layer.cornerRadius = 5
        TextField.layer.masksToBounds = false
        TextField.layer.shadowRadius = 2.0
        TextField.layer.shadowColor = UIColor.black.cgColor
        TextField.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        TextField.layer.shadowOpacity = 1.0
        TextField.layer.shadowRadius = 1.0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Please enter the description of the schedule"){
            textView.text = ""
            TextField.textColor = UIColor.black
        }
        textView.becomeFirstResponder()
    }
    
   // func tappedAwayFunction
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
   
    func pickerView(_ pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        if component == 0
        {
            
            let count = self.day.count
            return count
        }
        else if component == 1
        {
            
            let count = self.hour.count
           return count
        }
        else if component == 2
        {
            
            let count = self.minutes.count
            return count
        }
        return 0
    }

    
    
    @IBAction func GiveupSchedule(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
    @IBAction func SubmitSchedule(_ sender: Any) {
        
        let moc = DataController().managedObjectContext
        let temp = Task.init(entity: NSEntityDescription.entity(forEntityName: "Task", in:moc)!, insertInto: moc)
        temp.begin = ""
        temp.end = ""
        temp.desc = TextField.text
        temp.title = UITextLabel.text
        let begin = "\(createstringfromdate(date: record_date_begin)) \(hours.text! as String)\(Minute.text! as String)"
        let end = "\(createstringfromdate(date: record_date_end)) \(Remhours.text! as String)\(RemMinute.text! as String)"
        temp.fin_time = getdatefromstring(string: begin) as NSDate?
        temp.ram_time = getdatefromstring(string: end) as NSDate?
        temp.date = getstringfromdate_yy(date: Date())
        temp.id = Int64(Date().timeIntervalSince1970)
        print(temp.id)
        schedule.scheduleInstance.insertDate(schedule: temp)
        self.dismiss(animated: true, completion: nil);
 
        self.dismiss(animated: true, completion: nil);
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if 0 == component
        {
            
            let dictProvince = self.day[row]
            return dictProvince
        }
        else if 1 == component
        {
            
          return self.hour[row]
            
        }
        else if 2 == component
        {
            
           return self.minutes[row]
        }
        
        return nil
    }
    
    
    
    @IBAction func setRamtime(_ sender: Any) {
        changeflag = 2
        if(flag == 1){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.bringSubview(toFront: self.UIPickerView)
                self.UIPickerView.center.y = 400
            }, completion:{finish in
                
            })
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if 0 == component
        {
            if(changeflag == 1){
                Month.text = self.day[row]
                record_date_begin = self.date[row]}
            else{
                self.RemMonth.text = self.day[row]
                self.record_date_end = self.date[row]
            }
        }
        else if 1 == component
        {
            if(changeflag == 1){
                hours.text = "\(self.hour[row]as String):"
             show_hour.text = "\(self.hour[row]as String):" }
            else{
                Remhours.text = "\(self.hour[row]as String):"
                show_hour.text = "\(self.hour[row]as String):"
            }
            
        }
        else if 2 == component
        {
            if(changeflag == 1){
                Minute.text = self.minutes[row]
             show_minute.text = self.minutes[row]
            }
            else{
                RemMinute.text = self.minutes[row]
                 show_minute.text = self.minutes[row]
            }
            
        }

        
    }
    
    @IBAction func Finish(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.UIPickerView.center.y = 1000
        }, completion: {finish in
            
        })
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        return CGFloat(127)
    }
    
    
    @IBAction func SetTime(_ sender: Any) {
        changeflag = 1
        if(flag == 1){
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.view.bringSubview(toFront: self.UIPickerView)
                self.UIPickerView.center.y = 400
            }, completion:{finish in
                
            })
        }
    }
    
    
    
    func creatday(){
         date.append(Date())
        day.append("Today")
        for i in 1 ... 90{
            day.append(getstringfromdate(date: getnextdate(day: i)))
        }
    }
    
    
    func getnextdate(day : Int)-> Date{
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: day , to: Date())
        date.append(twoDaysAgo!)
        return twoDaysAgo!
    }
    
    
    func getstringfromdate(date : Date) -> String{
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/EEE"
        
        let now = dateformatter.string(from: date)
        return now

    }
    
    
    func getdatefromstring(string: String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd/EEE HH:mm"
        return formatter.date(from: string)!
    }

   
    
    func createstringfromdate(date : Date)->String{
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "yy/MM/dd/EEE"
        
        let now = dateformatter.string(from: date)
        return now
    }
    
    func getstringfromdate_yy(date: Date) -> String{
        let dateformatter = DateFormatter()
        
        dateformatter.dateFormat = "MM/dd/yy"
        
        let now = dateformatter.string(from: date)
        return now
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
