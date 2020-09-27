//
//  TreePageViewController.swift
//  realmTest2
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
import RealmSwift
class TreePageViewController: UIViewController,UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        self.goBackButton.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textField: UITextField!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let realm = try! Realm()
        let memoInstance:Memo = Memo()
        memoInstance.title = textField.text!
        try! realm.write{
            realm.add(memoInstance)
        }
        view.endEditing(true)
        
//        モーダルを閉じたときに、内容を親のビューコントローラで反映させる。
        let parentVC = self.presentingViewController as! ViewController
        parentVC.updateView()
        self.dismiss(animated: true, completion: nil)
        return true
    }
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
