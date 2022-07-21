import UIKit
import SnapKit

class ViewController: UIViewController {
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.label.textColor = .white
                buttonToggleBackground.backgroundColor = .white
                buttonToggleBackground.setTitleColor(.black, for: .normal)
            } else {
                self.view.backgroundColor = .white
                self.label.textColor = .black
                buttonToggleBackground.backgroundColor = .black
                buttonToggleBackground.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    var bruteForceDWI: DispatchWorkItem?
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.spacing = 20
        return stack
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aIndicator = UIActivityIndicatorView()
        return aIndicator
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Enter text here"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let buttonEye: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        button.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Введите пароль:"
        label.textAlignment = .center
        return label
    }()
    
    let buttonGenerate: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .link
        button.addTarget(self, action: #selector(generate), for: .touchUpInside)
        return button
    }()
    
    let buttonBruteForce: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start bruteforce", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(bf), for: .touchUpInside)
        return button
    }()
    
    let buttonToggleBackground: UIButton = {
        let button = UIButton()
        button.setTitle("Toggle background", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(toggleBackground), for: .touchUpInside)
        return button
    }()
    
    @objc func toggleBackground(){
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayout()
    }
    
    func setupHierarchy() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(textField)
        textField.addSubview(buttonEye)
        stackView.addArrangedSubview(buttonGenerate)
        stackView.addArrangedSubview(buttonBruteForce)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(buttonToggleBackground)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        textField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
        }
        buttonEye.snp.makeConstraints { make in
            make.top.bottom.equalTo(textField)
            make.right.equalTo(textField).offset(-5)
        }
        buttonGenerate.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
        }
        buttonBruteForce.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
        }
        buttonToggleBackground.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
        }
    }
    
    @objc func showHidePassword() {
        textField.isSecureTextEntry.toggle()
        changeIconEye()
    }
    
    func changeIconEye()
    {
        if textField.isSecureTextEntry {
            buttonEye.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        } else {
            buttonEye.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        }
    }
    
    @objc func generate() {
        let symbols = String().printable
        textField.text = String((0..<3).map{ _ in symbols.randomElement()! })
    }
    
    @objc func bf(){
        if(bruteForceDWI?.isCancelled != false) {
            buttonBruteForce.setTitle("Stop bruteForce", for: .normal)
            buttonBruteForce.backgroundColor = .red
            let passwordToUnlock: String = textField.text ?? ""
            bruteForceDWI = DispatchWorkItem {
                self.bruteForce(passwordToUnlock: passwordToUnlock)
            }
            let queue = DispatchQueue(label: "bruteforce",qos: .default)
            guard let bruteForceDWI = bruteForceDWI else {return}
            queue.async(execute: bruteForceDWI)
        } else {
            bruteForceDWI?.cancel()
        }
    }
    
    func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        var password: String = ""
        
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = false
            self.activityIndicator.startAnimating()
        }
        
        while password != passwordToUnlock {
            guard let item = bruteForceDWI, !item.isCancelled else {
                break
            }
            password = BruteForce().generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
            DispatchQueue.main.async {
                self.label.text = "Идет подбор: " + password
            }
        }
        
        DispatchQueue.main.async {
            self.buttonGenerate.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.bruteForceDWI?.cancel()
            if password == passwordToUnlock {
                self.label.text = "Взломаный пароль: " + password
            } else {
                self.label.text = "Пароль не взломан."
            }
            self.textField.isSecureTextEntry = false
            self.changeIconEye()
            self.buttonBruteForce.setTitle("Start bruteforce", for: .normal)
            self.buttonBruteForce.backgroundColor = .green
        }
    }
}

