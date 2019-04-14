//
//  displayView.swift
//  letsGetThisBread
//
//  Created by gautam on 1/1/19.
//  Copyright © 2019 gautam. All rights reserved.
//

import UIKit
import AVFoundation


class displayView: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    
    var audioPlayer: AVAudioPlayer?
    
    var p1Index = 0
    
    @IBOutlet weak var p1: UILabel!
    

    func run(after seconds: Int, completion: @escaping () -> Void)
    {
        let deadline = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadRhymes()
        updateWord()
    }
    
    @IBAction func updateSentence(_ sender: Any) {
        p1.text = "loading..."
        guard let button = Bundle.main.path(forResource: "button", ofType: "wav")
            else { return }
        let urlButton = URL(fileURLWithPath: button)
        audioPlayer = try?AVAudioPlayer(contentsOf: urlButton, fileTypeHint: nil)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        updateWord()
    }
    func updateWord()
    {
            run(after: 2) {
                if(self.p1Index < rhymingWords.count)
                {
                    self.p1.text = "Let's " + verb + " this " + rhymingWords[self.p1Index]
                    self.p1Index += 1
                }
                else
                {
                    self.p1.text = "No more bread :("
                }
            }

    }
    
    
    func downloadRhymes()
    {
        run(after: 1) {
            let url1 = URL(string: "https://api.datamuse.com//words?rel_rhy=" + verb)
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
                                if (breadSyn.contains(word))
                                {
                                    rhymingWords.append(word)
                                }
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
    
    
    @IBAction func more(_ sender: Any) {
        
        rhymingWords.removeAll()
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       guard let button = Bundle.main.path(forResource: "button", ofType: "wav")
        else { return }
       let urlButton = URL(fileURLWithPath: button)
        audioPlayer = try?AVAudioPlayer(contentsOf: urlButton, fileTypeHint: nil)
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
        
    }


}
