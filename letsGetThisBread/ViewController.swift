//
//  ViewController.swift
//  letsGetThisBread
//
//  Created by gautam on 1/1/19.
//  Copyright © 2019 gautam. All rights reserved.
//

import UIKit
import AVFoundation

var verb = ""
var rhymingWords = [String]()
var breadSyn = [String]()

class ViewController: UIViewController {

    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let path = Bundle.main.path(forResource: "button", ofType: "wav")
            else{ return }
        let url = URL(fileURLWithPath: path)
        audioPlayer = try?AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func downloadBread()
    {
        run(after: 1) {
            let url1 = URL(string: "https://api.datamuse.com//words?ml=bread&max=1000")
            let task = URLSession.shared.dataTask(with: url1!) { (data, response, error) in
                if (error != nil)
                {
                    print("ERROR")
                }
                else
                {
                    if let content = data
                    {
                        do
                        {
                            let myJSON = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            for aWord in myJSON as! [Dictionary<String,AnyObject>] {
                                let word = aWord["word"] as! String
                                breadSyn.append(word)
                                print(word)
                                
                            }
                        }
                        catch
                        {
                            print("JSON processing failed")
                        }
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    

    @IBAction func clicked(_ sender: Any) {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        downloadBread()
        run(after: 2)
        {
        breadSyn.append("bread")
        self.performSegue(withIdentifier: "1", sender: self)
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
        
    }
    
   
    
}

