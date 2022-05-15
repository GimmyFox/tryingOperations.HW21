//
//  ViewController.swift
//  tryingOperationd.HW21
//
//  Created by Maksim Guzeev on 15.05.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var generatePassButton: UIButton!
    @IBOutlet weak var changeColorButton: UIButton!
    
    
    @IBAction func generateButtonAction(_ sender: UIButton) {
        textField.isSecureTextEntry = true
        changeColorButton.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        label.text = "Идет подбор пароля..."
        let queue = OperationQueue()
        let bruteForceOperation = BruteForceOperation(password: textField.text ?? "Пароль нечитаемый")
        let mainQueue = OperationQueue.main
        let bruteForceCompletionHandler = BlockOperation {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.label.text = "Пароль сгенерирован: \(self.textField.text ?? "")"
            self.textField.isSecureTextEntry = false
        }
        
        queue.addOperation(bruteForceOperation)
        bruteForceOperation.completionBlock = {
            mainQueue.addOperation(bruteForceCompletionHandler)
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
}


