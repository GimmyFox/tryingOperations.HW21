//
//  ViewController.swift
//  tryingOperationd.HW21
//
//  Created by Maksim Guzeev on 15.05.2022.
//

import UIKit

class ViewController: UIViewController {

    
    let passwordLength = 2
    
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    
    
    @IBAction func generateButtonAction(_ sender: Any) {
        self.startCracking()
        
        let password = textField.text ?? "Пароль нечитаемый"
//        let splitPass = password.components(withMaxLength: passwordLength)
        let bruteForce = BruteForceOperation(password: password)
//        var bruteForceArray = [BruteForceOperation]()

//        splitPass.forEach { i in
//            print(i)
//            bruteForceArray.append(BruteForceOperation(password: i))
//            print(i)
//        }
//        print(splitPass)
//
        let queue = OperationQueue()
//
//        let mainQueue = OperationQueue.main

//        bruteForceArray.forEach { operation in
//            queue.addOperation(operation)
//            print("operation added")
//        }
//
//        queue.addBarrierBlock { [unowned self] in
//            mainQueue.addOperation {
//                self.stopCracking()
//            }
//        }
        
        bruteForce.completionBlock = {
            DispatchQueue.main.async {
                self.stopCracking()
            }
        }
        queue.addOperation(bruteForce)
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.label.text = "Идет подбор пароля... \(bruteForce.password)"
            print(bruteForce.password)
            if !bruteForce.isExecuting {
                timer.invalidate()
            }
        }
        timer.fire()
    }
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                label.textColor = .white
            } else {
                self.view.backgroundColor = .white
                label.textColor = .black
            }
        }
    }
    
    @IBAction func changeColorAction(_ sender: UIButton) {
        isBlack.toggle()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView(){
        label.text = "Введите пароль"
        activityIndicator.isHidden = true
        changeColorButton.isHidden = true
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
    }
    
    func startCracking() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        label.text = "Идет подбор пароля..."
        changeColorButton.isHidden = false
        generatePassButton.isEnabled = false
        changeColorButton.isEnabled = true
        textField.isEnabled = false
        if textField.text?.isEmpty == true {
            textField.text = textField.text?.newPassword(of: passwordLength)
        } else {
            textField.text = textField.text
        }
    }
    
    func stopCracking() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        label.text = "Пароль сгенерирован: \(self.textField.text ?? "")"
        textField.isSecureTextEntry = false
        generatePassButton.isEnabled = true
        changeColorButton.isEnabled = false
        textField.isEnabled = true
    }

}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
    
    func newPassword(of count: Int) -> String {
        let characters = (digits + lowercase + uppercase).map { String($0) }
        var password = ""
        
        for _ in 0..<count {
            password += characters.randomElement() ?? ""
        }
        
        return password
    }
    
    func components(withMaxLength length: Int) -> [String] {
        return stride(from: 0, to: self.count, by: length).map {
            let start = self.index(self.startIndex, offsetBy: $0)
            let end = self.index(start, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            return String(self[start..<end])
        }
    }
}


