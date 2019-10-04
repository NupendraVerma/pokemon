

import UIKit
import Kingfisher
import FirebaseAuth
import JGProgressHUD

var USER_ANS = 0

class QuizController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var imgPokemon:UIImageView!
    @IBOutlet weak var btnOptA:UIButton!
    @IBOutlet weak var btnOptB:UIButton!
    @IBOutlet weak var btnOptC:UIButton!
    @IBOutlet weak var btnOptD:UIButton!
    
    @IBOutlet weak var btnNext:UIButton!
    
    var model_Pokemon = [mPokemon_Data]()
    var model_QuizAns = [mQuizAns_Data]()
    var model_UserAns = [mUserQuizAns_Data]()
    
    var progress = JGProgressHUD(style: .dark)
    var pokemon_id = [Int]()
    var getAnsArray = [Int]()
    var id = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let range = 1...25
        pokemon_id = range.randomVal(7)
        btnNext.setTitle("Next", for: .normal)
        
        progress.textLabel.text = "Loading..."
        progress.show(in: self.view)
        callPokemonDetailsAPI()
        
    }
    
    @IBAction func A_optSelect(_ sender:UIButton){
        if let optA = sender.title(for: .normal) {
            USER_ANS = Int(optA)!
        }
        self.btnNext.isEnabled = true
        self.btnOptA.layer.cornerRadius = 10
        self.btnOptA.layer.borderWidth = 1.5
        self.btnOptA.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.btnOptB.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptC.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptD.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func B_optSelect(_ sender:UIButton){
        if let optB = sender.title(for: .normal) {
            USER_ANS = Int(optB)!
        }
        self.btnNext.isEnabled = true
        self.btnOptB.layer.cornerRadius = 10
        self.btnOptB.layer.borderWidth = 1.5
        self.btnOptB.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.btnOptA.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptC.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptD.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func C_optSelect(_ sender:UIButton){
        if let optC = sender.title(for: .normal) {
            USER_ANS = Int(optC)!
        }
        self.btnNext.isEnabled = true
        self.btnOptC.layer.cornerRadius = 10
        self.btnOptC.layer.borderWidth = 1.5
        self.btnOptC.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.btnOptA.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptB.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptD.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    @IBAction func D_optSelect(_ sender:UIButton){
        if let optD = sender.title(for: .normal) {
            USER_ANS = Int(optD)!
        }
        self.btnNext.isEnabled = true
        self.btnOptD.layer.cornerRadius = 10
        self.btnOptD.layer.borderWidth = 1.5
        self.btnOptD.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        self.btnOptA.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptB.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.btnOptC.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    

    @IBAction func reloadAPI(_ sender:UIButton){
        print("id==\(id)")
        if btnNext.tag == 7{
            let user_ans = mUserQuizAns_Data(userAnswer: USER_ANS)
            self.model_UserAns += [user_ans]
            let result_vc = storyboard?.instantiateViewController(withIdentifier: "AnswerControllerVC")as! AnswerController
            result_vc.model_QuizAns = self.model_QuizAns
            result_vc.model_UserQuizAns = self.model_UserAns
            self.present(result_vc,animated: true,completion: nil)
        }else{
            self.btnOptA.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnOptB.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnOptC.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.btnOptD.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let user_ans = mUserQuizAns_Data(userAnswer: USER_ANS)
            self.model_UserAns += [user_ans]
            
            progress.textLabel.text = "Loading..."
            progress.show(in: self.view)
            callPokemonDetailsAPI()
        }
        
    }
    
    func callPokemonDetailsAPI(){
        let params = ["":""]
        
        ApiHandler.POKEMON_ID = String(pokemon_id[id])
        
        getAnsArray.removeAll()
        
        ApiHandler().postData(url: ApiHandler.POKEMON_ID, params: params,onGetSuccess: {
            result in
            DispatchQueue.main.async {
                print(result)
                self.progress.dismiss()
                let weight  = result["weight"] as? Int ?? 0
                let height  = result["height"] as? Int ?? 0
                let sprites = result["sprites"]as? [String:Any]
                let imgpath = sprites!["front_default"]as? String ?? ""
               
                let api_data = mPokemon_Data(height: height, weight: weight, imgPath: imgpath)
                self.model_Pokemon += [api_data]
                
                let quiz_ans = mQuizAns_Data(answer: weight)
                self.model_QuizAns += [quiz_ans]
                
                self.dataFilling(index: self.id)
                self.id += 1
                self.btnNext.tag = self.id
                if self.btnNext.tag == 7{
                    self.btnNext.setTitle("Get Result", for: .normal)
                }
                self.btnNext.isEnabled = false
            }
        }, onFailure: {
            error in
            self.progress.dismiss()
            self.showAlertMessgae(on: self, with: "Error", and: error.localizedDescription)
            
        })
    }
}

extension QuizController{
    func dataFilling(index:Int){
        
        self.imgPokemon.kf.indicatorType = .activity
        let url = URL(string: model_Pokemon[index].imgPath)
        self.imgPokemon.kf.setImage(with: url)
        
        var correct_weight = model_Pokemon[index].weight
        
        self.getAnsArray.append(model_Pokemon[index].weight)
        for _ in 1...2{
            correct_weight += 1
            self.getAnsArray.append(correct_weight)
        }
        for _ in 1...1{
            self.getAnsArray.append(model_Pokemon[index].weight-1)
        }
        getAnsArray = self.getAnsArray.shuffled()
        self.btnOptA.setTitle(String(self.getAnsArray[0]), for: .normal)
        self.btnOptB.setTitle(String(self.getAnsArray[1]), for: .normal)
        self.btnOptC.setTitle(String(self.getAnsArray[2]), for: .normal)
        self.btnOptD.setTitle(String(self.getAnsArray[3]), for: .normal)

    }
    
}

