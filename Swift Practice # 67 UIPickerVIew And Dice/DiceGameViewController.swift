//
//  DiceGameViewController.swift
//  Swift Practice # 67 UIPickerVIew And Dice
//
//  Created by Dogpa's MBAir M1 on 2021/8/27.
//

import UIKit

class DiceGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var DiceImageVIew: [UIImageView]!                     //骰子的照片Outlet collection
    
    @IBOutlet weak var chooseResultTypePickerView: UIPickerView!    //選擇玩法的UIPickerView
    
    @IBOutlet weak var guessWhatLabel: UILabel!                     //顯示玩家猜測內容
    
    @IBOutlet weak var smallOrBigResultLabel: UILabel!              //顯示大小結果
    
    @IBOutlet weak var pointResultLabel: UILabel!                   //顯示點數結果
    
    
    //透過自訂義Struct建立Array的內容給chooseResultTypePickerView顯示
    let gameArray = [
        DiceGame(gameType: "猜大小", guseeResult: ["小","大"]),
        DiceGame(gameType: "猜點數", guseeResult: ["3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18"])
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //自定義決定是否顯示Label
        twoResultHideOrNot(sOrBLabel: true, pointLabel: true)
        //取得dataSource與delegate
        chooseResultTypePickerView.delegate = self
        chooseResultTypePickerView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    //自定義Func去判斷兩個Label是否隱藏或是顯示
    func twoResultHideOrNot (sOrBLabel:Bool, pointLabel:Bool){
        pointResultLabel.isHidden = pointLabel
        smallOrBigResultLabel.isHidden = sOrBLabel
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return gameArray.count
        }else{
            let selectGameType = chooseResultTypePickerView.selectedRow(inComponent: 0)
            return gameArray[selectGameType].guseeResult.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return gameArray[row].gameType
        }else{
            let selectGameType = chooseResultTypePickerView.selectedRow(inComponent: 0)
            return gameArray[selectGameType].guseeResult[row]
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        chooseResultTypePickerView.reloadComponent(1)
        checkPickerViewSelectType()
        pointResultLabel.text = ""
        smallOrBigResultLabel.text = ""
        twoResultHideOrNot(sOrBLabel: true, pointLabel: true)
        
    }
    
    //自定義選完chooseResultTypePickerView的後續執行內容
    func checkPickerViewSelectType (){
        let indexOfGameType = chooseResultTypePickerView.selectedRow(inComponent: 0)
        let indexOfResult = chooseResultTypePickerView.selectedRow(inComponent: 1)
        if indexOfGameType == 0 && indexOfResult > 1 {
            guessWhatLabel.textColor = .black
            guessWhatLabel.text = "請選擇賭什麼呦"
        }else{
            let type = gameArray[indexOfGameType].gameType
            let result = gameArray[indexOfGameType].guseeResult[indexOfResult]
            if indexOfGameType == 0 {
                guessWhatLabel.textColor = .red
                guessWhatLabel.text = "你\(type)   猜\(result)"
            }else{
                guessWhatLabel.textColor = .blue
                guessWhatLabel.text = "你\(type)   猜\(result)"
            }
        }
    }

    //自定義警告的func
    func alert (title:String, message:String, actionTitle:String){
        let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: actionTitle, style: .default)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
    }
    
    
    //摋骰子的BUtton
    @IBAction func rollDice(_ sender: UIButton) {
        
        //取得Component: 0 與 Component: 1的選擇Row數
        let gameTypeSelect = chooseResultTypePickerView.selectedRow(inComponent: 0)
        let gameResultSelect = chooseResultTypePickerView.selectedRow(inComponent: 1)
        
        //透過亂數顯示三顆骰子得擲骰子結果並使用迴圈加總三顆骰子總數
        let numberOfDice = DiceImageVIew.count-1
        var totalPoint = 0
        for dice in 0...numberOfDice{
            let ramdomIndex = Int.random(in: 1...6)
            totalPoint += ramdomIndex
            DiceImageVIew[dice].image = UIImage(systemName: "die.face.\(ramdomIndex)")
        }
        
        //依照擲骰子結果顯示pointResultLabel與smallOrBigResultLabel的內容
        pointResultLabel.text = "\(totalPoint)點"
        if totalPoint < 11 {
            smallOrBigResultLabel.text = "\(totalPoint) \(gameArray[0].guseeResult[0])"
        }else{
            smallOrBigResultLabel.text = "\(totalPoint) \(gameArray[0].guseeResult[1])"
        }
        
        
        //先判斷玩家是否有執行選擇UIPickerView的選擇
        //沒選chooseResultTypePickerView
        if guessWhatLabel.text == "" || guessWhatLabel.text == "請選擇賭什麼呦" || guessWhatLabel.text == "沒猜！！ 不算" {
            guessWhatLabel.text = "沒猜！！ 不算"
            twoResultHideOrNot(sOrBLabel: true, pointLabel: true)
            
        //有選沒選chooseResultTypePickerView
        }else{
            
            //判斷選了哪種類型
            //選猜大小
            if gameTypeSelect == 0 {
                //進行判斷是否猜對大小
                twoResultHideOrNot(sOrBLabel: false, pointLabel: true)      //隱藏點數Label顯示大小Label
                if (gameResultSelect == 0 && totalPoint < 11) || (gameResultSelect == 1 && totalPoint > 10) {
                    alert(title: "恭喜猜對", message: "請去隔壁領香腸", actionTitle: "開心")
                }else{
                    alert(title: "悲劇猜錯", message: "請你回家", actionTitle: "嗚嗚")
                }
            //選猜點數
            }else{
                //進行判斷是否猜對點數
                twoResultHideOrNot(sOrBLabel: true, pointLabel: false)      //顯示點數Label隱藏大小Label
                if (gameResultSelect + 3) == totalPoint {
                    alert(title: "太神啦猜中", message: "請去隔壁領香腸", actionTitle: "開心")
                }else{
                    alert(title: "猜對才有鬼", message: "請你回家", actionTitle: "嗚嗚")
                }
            }
        }
    }
    
    
    
    //重玩Button
    @IBAction func replay(_ sender: UIButton) {
        //隱藏兩個Label
        twoResultHideOrNot(sOrBLabel: true, pointLabel: true)
        //透過迴圈讓顯示骰子的照片變成問號
        let indexOfDice = DiceImageVIew.count-1
        for dice in 0...indexOfDice{
            DiceImageVIew[dice].image = UIImage(systemName: "questionmark")
        }
        //guessWhatLabel變成空字串沒有顯示內容
        guessWhatLabel.text = ""
    }
    
    
    
    

}
