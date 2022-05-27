//
//  ViewController.swift
//  tryingOperationd.HW21
//
//  Created by Maksim Guzeev on 15.05.2022.
//

import UIKit

class ViewController: UIViewController {

    
    let passwordLength = 10
    
    
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    
    
    @IBAction func generateButtonAction(_ sender: UIButton) {
        
        let password = textField.text ?? "Пароль нечитаемый"
        self.startCracking()
        
        let splitPass = password.components(withMaxLength: passwordLength)
        var bruteForceArray = [BruteForceOperation]()
        
        splitPass.forEach { i in
            bruteForceArray.append(BruteForceOperation(password: i))
        }
                
        let queue = OperationQueue()
        
        let mainQueue = OperationQueue.main

        bruteForceArray.forEach { operation in
            queue.addOperation(operation)
        }
        
        queue.addBarrierBlock {
            mainQueue.addOperation {
                self.stopCracking()
            }
        }
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


