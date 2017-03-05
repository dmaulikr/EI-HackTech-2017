//
//  ViewController.swift
//  turbotest
//
//  Created by Nikesh Shrestha on 3/4/17.
//  Copyright © 2017 Nik. All rights reserved.
//

import UIKit

private var responseData = "MasterToChange"

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func openCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func congnitiveAPI(_ sender: UIButton) {
        testmove(imageView: imagePicked)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicked.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(imagePicked.image!, 0.6)
        let compressedJPGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil )
        
        let alert = UIAlertView(title: "Wow", message: "Your image has been saved to Photo Library!",delegate: nil,
cancelButtonTitle: "Ok")
        alert.show()
    }
    
    
    func testmove(imageView: UIImageView){
        var request = URLRequest(url: URL(string: "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize")!)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField:"Content-Type")
        request.setValue("281847ed819f41a3804f7e6aa5d4a4d4", forHTTPHeaderField:"Ocp-Apim-Subscription-Key")
        
        
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)! as NSData
        
        let data = imageData as NSData
        request.httpBody = data as Data
        
    
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            responseData = responseString!
            
            let emotionReporter = self.showEmotionReport(result: responseString!)
            self.emotionAnalysis(emotionReport: emotionReporter)
        }
        task.resume()
    }
    
    func emotionAnalysis(emotionReport: [String:Double]) {
        let disgust = emotionReport["\"disgust\""]
        let sadness = emotionReport["\"sadness\""]
        let contempt = emotionReport["\"contempt\""]
        let fear = emotionReport["\"fear\""]
        let surprise = emotionReport["\"surprise\""]
        let neutral = emotionReport["\"neutral\""]
        let happiness = emotionReport["\"happiness\""]
        let anger = emotionReport["\"anger\""]
        
        let emotionArray = [disgust, sadness, contempt, fear, surprise, neutral, happiness, anger]
        
        // Finding largest numbers
        print(emotionArray)
        var maxVal = emotionArray[0]
        var index = 0
        var maxValIndex = 0
        // Chooses case based on which ever emotion has the highest value among the eight of them.
        for number in emotionArray {
            if Double(maxVal!) < Double(number!) {
                maxVal = number
                maxValIndex = index
            }
            index += 1
        }
        print(maxValIndex)
        switch maxValIndex {
        case 0:
            print("You are disgusted")
            disgustedmood()
        case 1:
            print("You are sad")
            sadmood()
        case 2:
            print("You are contempt")
            contemptmood()
        case 3:
            print("You are afraid")
            fearmood()
        case 4:
            print("You are surprised")
        case 5:
            print("You are neutral")
            neutralmood()
        case 6:
            print("Great! You are happy")
            happymood()
        case 7:
            print("You are angry")
            angrymood()
        default:
            print("You have dual emotions")
        }
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func surprisemood() {
        let alertController = UIAlertController(title: "Surprised :)", message: "Life is full of surprises. Hope this surprise was awesome!", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.happysong()
        })
        self.present(alertController, animated: true, completion: nil)

    }
    
    func neutralmood() {
        let alertController = UIAlertController(title: "", message: " Your mood is neutral. Try to cheer up a little bit! Hope this tune will lift up your mood.", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            let url = URL(string: "https://www.youtube.com/watch?v=9bZkp7q19f0&list=PLfx6wtMYilHBEHauY4vBx1iV_OhQGZqKZ&index=6&spfreload=5")
            if UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
                //If you want handle the completion block than
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                        print("Open url : \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }

        })
        self.present(alertController, animated: true, completion: nil)
            }
    
    func contemptmood() {
        let tipsPageURL = URL(string: "https://www.buzzfeed.com/joannaborns/boost-your-mood?utm_term=.ihb7BgNMe#.hnK6e2dPE")
        let application:UIApplication = UIApplication.shared
        let alertController = UIAlertController(title: "", message: "You are not worthless. Lots of Hugs! \n Do you want to read some posts lift up your mood!", preferredStyle:UIAlertControllerStyle.alert)
        let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            application.openURL(tipsPageURL!)
        })
        let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
            self.alert(message:"Have a break and rejuvenate!")
        })
        alertController.addAction(yesPressed)
        alertController.addAction(noPressed)
        present(alertController, animated: true, completion: nil)

    }
    
    func disgustedmood() {
        //alert(message: "You seem disgusted! Wanna hear some tunes?")
        let alertController = UIAlertController(title: "Disgusted??", message: "You seem disgusted! Wanna hear some happy tunes?", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.happysong()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func happysong() {
        let url = URL(string: "https://www.youtube.com/watch?v=y6Sxv-sUYtM")
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
            //If you want handle the completion block than
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
    
    func happymood() {
        let alertController = UIAlertController(title: "Happy", message: "You seem very happy! Let's share some happiness with your friends!", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            let url = URL(string: "https://www.facebook.com")
            if UIApplication.shared.canOpenURL(url!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url!)
                }
                //If you want handle the completion block than
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                        print("Open url : \(success)")
                    })
                } else {
                    UIApplication.shared.openURL(url!)
                }
            }

        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func angrymood() {
        alert(message: "Calm Down! You seem angry! Meditate Please!", title: "Angry??")
    }
    
    func sadmood() {
        let alertController = UIAlertController(title: "Disgusted??", message: "You seem disgusted! Wanna hear some happy tunes?", preferredStyle:UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            self.jokeMaker()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fearmood() {
        let strPhoneNumber = "911"
        if let phoneCallURL:URL = URL(string: "tel:\(strPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "Is anything wrong?", message: "Do you want to call \n\(strPhoneNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    application.openURL(phoneCallURL)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func jokeMaker() {
        let url = URL(string: "http://tambal.azurewebsites.net/joke/random")
        
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            let jokes = String(describing: json)
            print(jokes)
            let jokemessage = "Read this Joke and Smile" + jokes
            self.alert(message: jokemessage, title: "Joke Time")
        }
        
        task.resume()
    }
    
    func showEmotionReport(result: String) -> [String: Double]{
        
        // Create a CharacterSet of delimiters.
        var separators = CharacterSet(charactersIn: "[{,;")
        // Split based on characters.
        let parts = result.components(separatedBy: separators)
        var scores:[String:Double] = [:]
        if parts.count == 16{
            separators = CharacterSet(charactersIn: ":}]")
            var single = ""
            for index in 8...15 {
                single = parts[index]
                var singlepart = single.components(separatedBy: separators)
                let score_value = singlepart[1]
                scores[singlepart[0]] = Double(score_value)
            }
            
//            let alertController = UIAlertController(title: "Great", message: result, preferredStyle: .alert)
//            
//            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//                print("You've pressed OK button");
//            }
//            
//            alertController.addAction(OKAction)
//            self.present(alertController, animated: true, completion:nil)
            return scores
        }
        else {
            return [:]
        }
    }

    
  }


    
    




