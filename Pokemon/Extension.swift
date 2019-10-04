
import Foundation
import UIKit


extension UIViewController{
    func isValidate_textField(textfield:UITextField,errlbl:UILabel,ErrorMsg:String)-> Bool{
        if !(textfield.text?.isEmpty)!{
            errlbl.isHidden = true
            return true
        }else{
            errlbl.isHidden = false
            errlbl.text = ErrorMsg
            return false
        }
    }
    func showAlertMessgae(on viewcontroler: UIViewController, with title: String, and subtitle: String)
    {
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewcontroler.present(alert, animated: true, completion: nil)
    }
    func isValid_Email(textfield:UITextField,errlbl:UILabel,ErrorMsg:String)-> Bool{
        if !(textfield.text?.isValidEmail)!{
            errlbl.isHidden = true
            return true
        }else{
            errlbl.isHidden = false
            errlbl.text = ErrorMsg
            return false
        }
    }
    
}

extension String {
    var isValidEmail: Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

extension Collection {
    
    
    var randomVal : Element? {
        guard !isEmpty else { return nil }
        let offset = arc4random_uniform(numericCast(self.count))
        let idx = self.index(self.startIndex, offsetBy: numericCast(offset))
        return self[idx]
    }
    
    func randomVal(_ count : UInt) -> [Element] {
        let randomValCount = Swift.min(numericCast(count), self.count)
        
        var elements = Array(self)
        var randomVals : [Element] = []
        
        while randomVals.count < randomValCount {
            let idx = (0..<elements.count).randomVal!
            randomVals.append(elements.remove(at: idx))
        }
        
        return randomVals
    }
    
}
