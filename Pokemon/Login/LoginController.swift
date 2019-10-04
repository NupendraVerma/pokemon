
import UIKit
import JGProgressHUD
import FirebaseAuth

class LoginController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var tf_email:UITextField!
    @IBOutlet weak var tf_pass:UITextField!
    @IBOutlet weak var btnLogin:UIButton!
    @IBOutlet weak var btnSignup:UIButton!
    @IBOutlet weak var errEmail:UILabel!
    @IBOutlet weak var errPass:UILabel!
    
    let progress = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errPass.isHidden = true
        errEmail.isHidden = true
        btnLogin.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.5333333333, blue: 0.3803921569, alpha: 1)
        btnSignup.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.5333333333, blue: 0.3803921569, alpha: 1)
        btnLogin.layer.borderWidth = 1.5
        btnSignup.layer.borderWidth = 1.5
        btnLogin.layer.cornerRadius = 8
        btnSignup.layer.cornerRadius = 8
        
    }
    
    @IBAction func LoginAction(_ Sender:UIButton){
        
        let email = isValidate_textField(textfield: tf_email, errlbl: errEmail, ErrorMsg: "Required")
        let pass = isValidate_textField(textfield: tf_pass, errlbl: errPass, ErrorMsg: "Required")
        
        if email && pass{
            let valid = isValid_Email(textfield: tf_email, errlbl: errEmail, ErrorMsg: "Invalid email")
            if !valid {
                errEmail.isHidden = true
                progress.textLabel.text = "Loading..."
                progress.show(in: self.view)
                Auth.auth().signIn(withEmail: tf_email.text!, password: tf_pass.text!) { (user, error) in
                    if user != nil{
                        self.progress.dismiss()
                        let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "QuizControllerVC")as! QuizController
                        self.present(quizVC,animated: true,completion: nil)
                    }else{
                        self.progress.dismiss()
                        self.showAlertMessgae(on: self, with: "Error", and: "Something went wrong")
                    }
                }
            }else{
                errEmail.isHidden = false
                errEmail.text = "Invalid email"
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if nextResponder != nil {
            nextResponder?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
