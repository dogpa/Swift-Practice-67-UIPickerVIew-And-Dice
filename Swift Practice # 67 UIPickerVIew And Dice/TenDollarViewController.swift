//
//  TenDollarViewController.swift
//  Swift Practice # 67 UIPickerVIew And Dice
//
//  Created by Dogpa's MBAir M1 on 2021/8/27.
//

import UIKit

class TenDollarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var tenDollarUIImageView: UIImageView!           //顯示十元照片
    
    @IBOutlet weak var guessUpOrDownUIPickerVIew: UIPickerView!     //選擇要猜的大小
    
    @IBOutlet weak var guessWhatUILabel: UILabel!                   //顯示猜的內容
    
    @IBOutlet weak var guessResultUILabel: UILabel!                 //顯示結果
    
    let guessArray = ["正面","反面"]                                  //定義一個Array給UIPickerView使用
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guessWhatUILabel.text = "請猜正反面！"                        //guessWhatUILabel讀入後預設顯示內容
        
        //UIPickerViewDelegate, UIPickerViewDataSource的尋求資料的位置(找誰要顯示的內容)
        guessUpOrDownUIPickerVIew.dataSource = self
        guessUpOrDownUIPickerVIew.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //guessUpOrDownUIPickerVIew顯示的component數量
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //guessUpOrDownUIPickerVIew顯示的row數量
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return guessArray.count
    }
    
    //guessUpOrDownUIPickerVIew顯示的row的顯示內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return guessArray[row]
    }
    
    //選則guessUpOrDownUIPickerVIew後要執行的事項
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let guessWhat = guessUpOrDownUIPickerVIew.selectedRow(inComponent: 0)
        if guessWhat == 0 {
            guessWhatUILabel.text = "你猜銅板 \(guessArray[0])"
            guessWhatUILabel.textColor = .red
        }else if guessWhat == 1 {
            guessWhatUILabel.text = "你猜銅板 \(guessArray[1])"
            guessWhatUILabel.textColor = .blue
        }
    }
    
    //自定義Func根據猜的結果顯示不同的警告內容
    func alert (title:String, message:String, actionTitle:String){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: actionTitle, style: .default)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
    }
    
    
    
    //猜猜看的Button
    @IBAction func ShowTheResult(_ sender: UIButton) {
        
        tenDollarUIImageView.isHidden = false           //顯示tenDollarUIImageView
        let randomIndex = Int.random(in: 0...1)         //產生隨機亂數
        tenDollarUIImageView.image = UIImage(named: "\(randomIndex)")   //照片顯示結果依照亂數出來的數字指定
    
        //先從guessWhatUILabel的顯示內容去判斷玩家有無進行猜大小
        //如果沒猜
        if guessWhatUILabel.text == "" || guessWhatUILabel.text == "再猜一次吧" || guessWhatUILabel.text == "是要不要猜？" || guessWhatUILabel.text == "請猜正反面！" {
            guessWhatUILabel.text = "是要不要猜？"    //guessWhatUILabel顯示內容改變
            tenDollarUIImageView.isHidden = true    //隱藏tenDollarUIImageView的狀況
            
        //如果有猜，在判斷有沒有猜對。
        }else{
            tenDollarUIImageView.isHidden = false     //顯示tenDollarUIImageView
            //猜對的狀況執行改變guessResultUILabel顯示內容以及自定義Func
            if randomIndex == guessUpOrDownUIPickerVIew.selectedRow(inComponent: 0){
                guessResultUILabel.text = "恭喜猜對！"
                alert(title: "恭喜猜對 是\(guessArray[randomIndex])！", message: "請向媽媽拿十塊", actionTitle: "開心")
            //猜錯的狀況執行改變guessResultUILabel顯示內容以及自定義Func
            }else{
                guessResultUILabel.text = "可惜猜錯"
                alert(title: "可惜猜錯", message: "請給媽媽十塊", actionTitle: "嗚嗚")
            }
        }

    
    }
    
    
    //重玩的Button
    @IBAction func restartToPlay(_ sender: UIButton) {
        tenDollarUIImageView.isHidden = true        //隱藏tenDollarUIImageView
        guessWhatUILabel.text = "再猜一次吧"          //改變 guessWhatUILabel顯示內容
        guessWhatUILabel.textColor = .black         //改變guessWhatUILabel字體顏色
        guessResultUILabel.text = ""                // guessResultUILabel變空字串
    }
    
}
