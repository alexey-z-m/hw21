import Foundation

extension ViewController {
    
    @objc func bf(){
        let passwordToUnlock: String = self.textField.text ?? ""
        bruteForceIsRunning = true
        let bruteForceDWI = DispatchWorkItem {
            self.bruteForce(passwordToUnlock: passwordToUnlock)
        }
        let quere = DispatchQueue(label: "bf",qos: .default)
        quere.async(execute: bruteForceDWI)
    }
    
    @objc func stopBruteForce(){
        bruteForceIsRunning = false
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = false
            self.activityIndicator.startAnimating()
            self.bruteForceIsRunning = true
        }
        while password != passwordToUnlock {
            if !self.bruteForceIsRunning {
                break
            }
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            print(password)
            DispatchQueue.main.async {
                self.label.text = "Идет подбор: " + password
            }
        }
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = true
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
}

extension ViewController {
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
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }
        return str
    }
}
