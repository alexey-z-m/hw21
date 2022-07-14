import UIKit
import SnapKit

class ViewController: UIViewController {

    var bruteForceIsRunning = false
    
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
    
    let textViewConsole: UITextView = {
        let textView = UITextView()
        textView.keyboardDismissMode = .none
        return textView
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
        label.textColor = .black
        return label
    }()
    
    let buttonGenerate: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(generate), for: .touchUpInside)
        return button
    }()
    
    let buttonBruteForce: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BruteForce", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(bf), for: .touchUpInside)
        return button
    }()
    
    let buttonStop: UIButton = {
        let button = UIButton()
        button.setTitle("Stop BruteForce", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(stopBruteForce), for: .touchUpInside)
        return button
    }()
    
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
        stackView.addArrangedSubview(buttonStop)
        view.addSubview(textViewConsole)
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
        buttonStop.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(100)
            make.right.equalToSuperview().offset(-100)
        }
        textViewConsole.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
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
}

