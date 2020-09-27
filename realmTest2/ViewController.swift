//
//  ViewController.swift
//  realmTest2
//
//  Created by 松尾淳平 on 2020/09/27.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
//    セクション内の行数を返します。（今回は、セクションが一つです。）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCells.count
    }
//    セルを作ります。
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let tempCell = self.tableCells[(indexPath as IndexPath).row]
        cell.textLabel?.text = tempCell.title
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        delegateとdataSouceを設定します。忘れがちなので、整理すること
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        DBにあるデータを格納します。
        self.tableCells = realm.objects(Memo.self)
//        ボタンを丸くしているだけです。
        tweetButton.layer.cornerRadius = 10.0
    }

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetButton: UIButton!
    
//    セグエを実装しています。
    @IBAction func tweet(_ sender: Any) {
        let nextVC = self.storyboard?.instantiateViewController(identifier: "tweetPage")
        present(nextVC!, animated: true,completion: nil)
    }
//    DBの値を格納する箱を用意しておきます。
    var tableCells: Results<Memo>!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        let memoInstance: Memo = Memo()
        memoInstance.title = textField.text!
        let realm = try! Realm()
        try! realm.write{
            realm.add(memoInstance)
        }
        self.tableView.reloadData()
        view.endEditing(true)
        return true
    }
//    データをリロードします。（モーダルを閉じた際に親側でデータを更新するのに使います。
    func updateView(){
        self.tableView.reloadData()
    }
    
//
    @IBAction func tapView(_ sender: Any) {
        view.endEditing(true)
    }
  
//    このコードはあってもなくても変わらなかった
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
//    行タップした際に、アラートを出現させます。アラート内で更新ボタンをタップした場合は、テキストフィールドを持った別アラートを出現させます。
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        選択肢を3つ持つアラートを作成します。
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "\(self.tableCells[indexPath.row].title!)をどうしましょう？"
        alert.addAction(UIAlertAction(
            title:"更新する",style: .default,handler: { (action) in
                print("更新する")
//                更新するをタップした場合、テキストフィールドを持つ別アラートを出現させます。
                let alertInput = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alertInput.title="入力してください"
//                delegateをselfします。（正直ここはよくわかりません。）
                alertInput.addTextField{(textField) -> Void in textField.delegate = self}
                alertInput.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
                    let realm = try! Realm()
                    try! realm.write{
//                        テキストフィールドの値を取り出します。nilだった場合、何もしない選択をするようにguard letを使用します。（これは全く理解していません。）
                        guard let textFields = alertInput.textFields else {return}
//                        textFieldsは複数のテキストフィールドを持てるので、今回は一つ目のテキストフィールドを取り出します。
                        self.tableCells[indexPath.row].title = textFields[0].text
                    }
                    self.tableView.reloadData()
                }))
                alertInput.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
                self.present(alertInput, animated: true, completion: nil)
//                選択を解除する。これをしないとずっと選択されたままになる。（まあそれでもいいけど）
                self.tableView?.deselectRow(at: indexPath, animated: true)
            }))
        alert.addAction(UIAlertAction(title: "削除する", style: .destructive, handler: { (action) in
            let realm = try! Realm()
            try! realm.write{
                realm.delete(self.tableCells[indexPath.row])
            }
            self.tableView.reloadData()
            
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

