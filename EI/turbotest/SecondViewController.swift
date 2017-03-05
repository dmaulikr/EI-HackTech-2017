//
//  SecondViewController.swift
//  NavigationControllerExample
//

//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func jsonTest(_ sender: UIButton) {
        let urlString = "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize"
        let session = URLSession.shared
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(url: url as URL)
        
        request.setValue("Content-Type", forKey: "application/json")
        request.setValue("Ocp-Apim-Subscription-Key", forKey: "281847ed819f41a3804f7e6aa5d4a4d4")
        
        session.dataTask(with: request as URLRequest){(data,response, error) -> Void in
            
            if let responseData = data
            {
                do{
                    let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                }catch{
                    print("Could not serialize")
                }
            }
            
            }.resume()
        
    }
}
