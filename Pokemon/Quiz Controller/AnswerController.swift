

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AnswerController: UIViewController {

    @IBOutlet weak var lblLatestAns:UILabel!
    @IBOutlet weak var lblHighestAns:UILabel!
    @IBOutlet weak var btnLogout:UIButton!
    @IBOutlet weak var btnPlayagain:UIButton!
    @IBOutlet weak var tblAnswer:UITableView!
    
    var ref: DatabaseReference!
    
    var model_QuizAns = [mQuizAns_Data]()
    var model_UserQuizAns = [mUserQuizAns_Data]()
    var counter = 0
    var getHighScore = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblAnswer.reloadData()
        btnLogout.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.5333333333, blue: 0.3803921569, alpha: 1)
        btnPlayagain.layer.borderColor = #colorLiteral(red: 0.03529411765, green: 0.5333333333, blue: 0.3803921569, alpha: 1)
        btnLogout.layer.borderWidth = 1.5
        btnPlayagain.layer.borderWidth = 1.5
        btnLogout.layer.cornerRadius = 8
        btnPlayagain.layer.cornerRadius = 8
        //commmit test
    }
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.getHighScore = value!["high_score"]as? Int ?? 0
            self.lblHighestAns.text = "\(value!["high_score"]as? Int ?? 0)"
        }) { (error) in
            self.lblHighestAns.text = "-"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                
                if self.counter > self.getHighScore{
                    self.ref.child("Users/\(user!.uid)/").setValue(["high_score": self.counter])
                    self.viewWillAppear(true)
                }
            }
        }
    }
    
    @IBAction func logoutAction(_ sender:UIButton){
        do{
            try Auth.auth().signOut()
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginControllerVC")as! LoginController
            self.present(loginVC,animated: true,completion: nil)
        }catch{
            self.showAlertMessgae(on: self, with: "Error", and: "Something went wrong")
        }
    }

}

extension AnswerController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model_QuizAns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ansTableCell", for: indexPath)as! ansTableCell
        if model_QuizAns.count != 0 && model_UserQuizAns.count != 0{
            if model_QuizAns[indexPath.row].answer == model_UserQuizAns[indexPath.row].userAnswer{
                cell.lblAns.textColor = #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)
                counter += 1
                self.lblLatestAns.text = "\(counter)"
                
            }else{
                cell.lblAns.textColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
            }
            cell.lblAns.text = "\(model_QuizAns[indexPath.row].answer)"
            cell.lblTitle.text = "Answer \(indexPath.row+1) :"
        }
        return cell
    }
    
    
}

class ansTableCell:UITableViewCell{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAns: UILabel!
}
