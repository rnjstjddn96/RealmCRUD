//
//  ViewController.swift
//  RealmPrac
//
//  Created by 권성우 on 2020/06/08.
//  Copyright © 2020 권성우. All rights reserved.
//

import UIKit
import RealmSwift


class Person : Object{
    @objc dynamic var name = ""
    @objc dynamic var age = ""
}

class ViewController: UIViewController{
    
    /*dynamic 키워드를 붙이는 이유는 Runtime 일때, Realm이 자동으로 변수의 변화를 탐지하기 위해서이고 이러한 과정이 objective-c를 통해 이루어지기 때문에 @objc 키워드를 덧붙입니다.*/
    var realm : Realm?
    var personList : Results<Person>? //Person의 데이터
    //var notificationtoken : NotificationToken?
    /*Realm은 PushDriven 이기 때문에 NotificationToken을 사용해
     구독하여 실시간으로 업데이트가 가능.*/
    
    
    //TextField
    @IBOutlet weak var tfAge: UITextField!
    @IBOutlet weak var tfName: UITextField!
    
    //TableView
    @IBOutlet weak var tvPerson: UITableView!
    
    
    //Create 과정 수행
    func createData(database: Person)-> Person{
        if let name = tfName.text{
            database.name = name
        }
        if let age = tfAge.text{
            database.age = age
        }
        return database
    }
    @IBAction func addAction(_ sender: UIButton) {
        try! realm!.write{
            realm!.add(createData(database: Person()))
        }
    }
    
    //Delete 과정 수행
    @IBAction func deleteData(_ sender: UIButton) {
        
        let chooseName = realm!.objects(Person.self).filter("name='\(tfName.text!)'")
        let finalChoose = chooseName.filter("age='\(tfAge.text!)'")
            do {
                try realm!.write{
                    realm!.delete(finalChoose)
                }
            }catch{
                print("Err")
            }
        
    }
    
    //Update과정 수행
    @IBAction func updateData(_ sender: UIButton) {
        try! realm?.write {
            guard let personList = personList else { return }
            personList.forEach({ (list) in
                if let name = tfName.text, let age = tfAge.text {
                    if list.name == name {
                        list.name = name
                        list.age = age
                    }
                }
            })
        }
    }
    
    //Read과정 수행
    @IBAction func readData(_ sender: UIButton) {
        print(realm!.objects(Person.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        realm = try? Realm()
        personList = realm?.objects(Person.self)
        
        //notificationtoken = personList!.observe({(change) in print("change :",change)
         //   self.tvPerson.reloadData() })
        print(NSHomeDirectory())
    }
   
    /*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //push driven 종료
        notificationtoken?.invalidate()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    deinit{
       notificationtoken?.invalidate()
    }
    */
    
}

