//
//  ViewController.swift
//  MyCalculator
//
//  Created by 나호진 on 2022/04/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var history: UILabel!
    @IBOutlet weak var result: UILabel!

    let maxNumButton = 9
    
    var printNum: Double = 0
    var howManyFraction: Int = 0
    var howManyDecimal: Int = 0
    var expressionArray: [String] = []
    var operation = 0 // +1, -2, *3, /4, %5
    var isFraction: Bool = false
    
    func resultChange(_ newNum: Double) {
        guard howManyDecimal + howManyFraction < maxNumButton else {
                  return
              }
              
              var fraction = newNum
              var powTen = 1
              
              if howManyFraction > 0 {
                  for _ in 0..<howManyFraction {
                      fraction *= 0.1
                      powTen *= 10
                      fraction = round(fraction * Double(powTen)) / Double(powTen)
                  }
                  printNum += fraction
                  printNum = round(printNum * Double(powTen)) / Double(powTen)
                  howManyFraction += 1
              }
              else {
                  howManyDecimal += 1
                  printNum = printNum * 10 + newNum
              }

              self.result.text = removeZero(num: printNum)
          }

    

    @IBAction func num1(_ sender: UIButton) {
        resultChange(1)
    }
    
    @IBAction func num2(_ sender: Any) {
        resultChange(2)
    }
    @IBAction func num3(_ sender: Any) {
        resultChange(3)
    }
    
    @IBAction func num4(_ sender: Any) {
        resultChange(4)
    }
    
    @IBAction func num5(_ sender: Any) {
        resultChange(5)
    }
    @IBAction func num6(_ sender: Any) {
        resultChange(6)
    }
    
    @IBAction func num7(_ sender: Any) {
        resultChange(7)
    }
    
    @IBAction func num8(_ sender: Any) {
        resultChange(8)
    }
    @IBAction func num9(_ sender: Any) {
        resultChange(9)
    }
    @IBAction func num0(_ sender: Any) {
        resultChange(0)
    }
    @IBAction func plus(_ sender: Any) {
        whenSelectedOperator(1)
    }
    @IBAction func minus(_ sender: Any) {
        whenSelectedOperator(2)
    }
    @IBAction func multiple(_ sender: Any) {
        whenSelectedOperator(3)
    }
    @IBAction func divide(_ sender: Any) {
        whenSelectedOperator(4)
    }
    @IBAction func remainder(_ sender: Any) {
        whenSelectedOperator(5)
    }
    @IBAction func dot(_ sender: Any) {
        if !isFraction {
            isFraction = true
            howManyFraction += 1
            self.result.text = removeZero(num: printNum) + "."
        }
    }
    @IBAction func clear(_ sender: Any) {
        printNum = 0
        howManyInit()
        expressionArray.removeAll()
        self.history.text = ""
        self.result.text = "0"
    }
    
    @IBAction func printResult(_ sender: Any) {
        print(expressionArray.description)
        self.history.text = expressionArray.joined(separator: " ")
        expressionArray.append("\n")
        getOtherValue(num: -1, lastCh: "\n")
        getAddSubValue(num: -1, lastCh: "\n")
        
        operation = 0
        printNum = Double(expressionArray.first!)!
        expressionArray.removeAll()
        howManyInit()
    }
    
    
     func getOtherValue(num: Int, lastCh: String) {
        var i = num
        var insertNum: Double = 0
        
        repeat {
            i += 1
            switch expressionArray[i] {
            case "*" :
                insertNum = operateTwoNum(Double(expressionArray[i-1])!, Double(expressionArray[i+1])!, operation: operateMultiply)
                for _ in 0..<3 { expressionArray.remove(at: i-1) }
                expressionArray.insert(String(insertNum), at: i-1)
                i -= 1
            case "/" :
                insertNum = operateTwoNum(Double(expressionArray[i-1])!, Double(expressionArray[i+1])!, operation: operateDivide)
                for _ in 0..<3 { expressionArray.remove(at: i-1) }
                expressionArray.insert(String(insertNum), at: i-1)
                i -= 1
            case "%" :
                insertNum = operateTwoNum(Double(expressionArray[i-1])!, Double(expressionArray[i+1])!, operation: operateRemainder)
                for _ in 0..<3 { expressionArray.remove(at: i-1) }
                expressionArray.insert(String(insertNum), at: i-1)
                i -= 1
            default:
                break
            }
            
        } while expressionArray[i] != lastCh
    }
    func getAddSubValue(num: Int, lastCh: String) {
        var i = num
                var insertNum: Double = 0

                repeat {
                    i += 1
                    switch expressionArray[i] {
                    case "+" :
                        insertNum = operateTwoNum(Double(expressionArray[i-1])!, Double(expressionArray[i+1])!, operation: operateAdd)
                        for _ in 0..<3 { expressionArray.remove(at: i-1) }
                        expressionArray.insert(String(insertNum), at: i-1)
                        i -= 1
                    case "-" :
                        insertNum = operateTwoNum(Double(expressionArray[i-1])!, Double(expressionArray[i+1])!, operation: operateSub)
                        for _ in 0..<3 { expressionArray.remove(at: i-1) }
                        expressionArray.insert(String(insertNum), at: i-1)
                        i -= 1
                    default:
                        break
                    }
                } while expressionArray[i] != lastCh
    }
    func whenSelectedOperator(_ num:Int) {
        if expressionArray.last != ")" && num != 6  || expressionArray.isEmpty && printNum != 0 {
            expressionArray.append(removeE(num: String(removeZero(num: printNum))))
        }
        switch num {
        case 1:
            expressionArray.append("+")
        case 2:
            expressionArray.append("-")
        case 3:
            expressionArray.append("*")
        case 4:
            expressionArray.append("/")
        case 5:
            expressionArray.append("%")
        default:
            break
        }
        self.history.text = expressionArray.joined(separator: " ")
        operation = num
        printNum = 0
        howManyInit()
    }
    func operateTwoNum(_ a: Double, _ b: Double, operation: (Double, Double) -> Double) -> Double {
        printNum = round(operation(a, b) * 1000000000000000) / 1000000000000000 // 소수점 아래 15자리에서 자르기
        self.result.text = removeZero(num: printNum) // 이하 0은 삭제 됨
        return printNum
    }
    
    var operateAdd: (Double, Double) -> Double = { $0 + $1 }
    var operateSub: (Double, Double) -> Double = { $0 - $1 }
    var operateMultiply: (Double, Double) -> Double = { $0 * $1 }
    var operateDivide: (Double, Double) -> Double = { $0 / $1 }
    var operateRemainder: (Double, Double) -> Double = { $0.truncatingRemainder(dividingBy: $1) }
    func removeZero(num: Double) -> String {
        let formatString = "%." + String(howManyFraction-1) + "f"
        let floatNumString = num == floor(num) ? String(format: formatString, num) : String(num)
        return removeE(num: floatNumString)
    }
    
    func removeE(num: String) -> String {
        let a = num
        
        if a.contains("e-") {
            var temp = ""
            
            for i in 0..<a.count {
                let index = a.index(a.startIndex, offsetBy: i)
                if a[index] == "e" { break }
                if a[index] == "." { continue }
                temp.append(a[index])
            }
            
            let start = a.index(a.startIndex, offsetBy: a.count-2)
            let end = a.index(a.startIndex, offsetBy: a.count)
            let sub = a[start..<end]
            
            var result = "0."
            for _ in 0..<Int(sub)!-1 { result.append("0") }
            result.append(temp)
            return result
        } else {
            return String(a)
        }
    }
    
    func howManyInit() {
        howManyDecimal = 0
        howManyFraction = 0
        isFraction = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
    

