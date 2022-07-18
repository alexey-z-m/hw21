import Foundation

extension ViewController {
    
    @objc func bf(){
        bruteForceIsRunning.toggle()
    }
    
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = false
            self.activityIndicator.startAnimating()
        }
        
        while password != passwordToUnlock {
            if !self.bruteForceIsRunning {
                self.bruteForceIsRunning = false
                break
            }
            let generator = PassworgGenerator()
            password = generator.generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
            DispatchQueue.main.async {
                self.label.text = "Идет подбор: " + password
            }
        }
        
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = true
            self.bruteForceIsRunning = false
            self.activityIndicator.stopAnimating()
            if password == passwordToUnlock {
                self.label.text = "Взломаный пароль: " + password
            } else {
                self.label.text = "Пароль не взломан."
            }
            self.textField.isSecureTextEntry = false
            self.changeIconEye()
        }
    }
}

class PassworgGenerator {
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string
        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last ?? Character(""), array) + 1) % array.count, array))
            if indexOf(character: str.last ?? Character(""), array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? Character(""))
            }
        }
        return str
    }
}
