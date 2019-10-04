

import UIKit
import Alamofire


class ApiHandler: NSObject {
    
    let BASEURL = "https://pokeapi.co/api/v2/pokemon/"
    static let sharedInstance = ApiHandler()
    
    
    static var POKEMON_ID = ""
    
    
    
    func postData(url : String,params: [String : Any], onGetSuccess: @escaping([String : Any]) -> Void, onFailure: @escaping(Error) -> Void)
    {
        
        let apiUrl = BASEURL+url
        print(apiUrl,params)
        Alamofire.request(apiUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseString
            {
                response in
                
                let httpStatusCode = response.response?.statusCode
                
                //print("httpStatusCode=",httpStatusCode!)
                if (httpStatusCode == 200)
                {
                    let resultData = response.result.value!
                    
                    let data = resultData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                    do
                    {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        
                        onGetSuccess(json)
                        
                    }
                    catch let error as NSError
                    {
                        
                        if error._code == NSURLErrorTimedOut {
                            print("HTTP STATUS ERROR CODE==\(error._code)::: Request timeout!")
                        }else{
                            print("HTTP STATUS ERROR CODE==\(error._code)")
                        }
                        onFailure(error)
                    }
                    
                }
                else if(httpStatusCode == 401)
                {
                    
                    let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey : "Authorisation Failed"])
                    
                    onFailure(error)
                }
                else
                {
                    switch (response.result) {
                    case .success: break 
                    case .failure(var error):
                        if error._code == NSURLErrorTimedOut {
                            print("HTTP STATUS ERROR CODE Time Out ==\(error._code)")
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "The Request Time Out."])
                            onFailure(error)
                        }else if error._code == NSURLErrorNetworkConnectionLost {
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Network Connection Lost."])
                            onFailure(error)
                        }else if error._code == NSURLErrorNotConnectedToInternet {
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Device Not Connected To Internet."])
                            onFailure(error)
                        }else if error._code == NSURLErrorCannotMoveFile {
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Cannot Move File"])
                            onFailure(error)
                        }else if error._code == NSURLErrorCannotWriteToFile {
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Cannot Write To File"])
                            onFailure(error)
                        }else if error._code == NSURLErrorCannotOpenFile {
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Cannot Open File"])
                            onFailure(error)
                        }else{
                            error = NSError(domain: "", code: error._code, userInfo: [NSLocalizedDescriptionKey : "Something went wrong try again !"])
                            onFailure(error)
                        }
                    }
                }
        }
    }
    
  
}
