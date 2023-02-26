//
//  SplashScreenViewController.swift
//
//  Created by Krystian Konieczko on 26/02/2023.
//

import UIKit
import AVFoundation

class SplashScreenViewController: UIViewController {
    
    var player: AVAudioPlayer?
    
    var backgroundEaten: UIImageView {
        return makeImageView(imageName: "splashScreen1")
    }

    var backgroundHalfEaten: UIImageView {
        return makeImageView(imageName: "splashScreen2")
    }

    var backgroundNotEaten: UIImageView {
        return makeImageView(imageName: "splashScreen3")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add imageView2 to the view
        view.addSubview(backgroundNotEaten)
        
        // Center imageView
        backgroundEaten.center = view.center
        
        let completion2 = {
            print("completion 2 executing...")
            self.animate(view: self.backgroundEaten, time: 0, soundName: "chrup 2", completion: self.goToAnotherView)
        }
        
        // Define the completion handlers for each animation
        let completion1 = {
            print("completion 1 executing...")
            self.animate(view: self.backgroundHalfEaten, time: 0, soundName: "chrup 1", completion: completion2)
        }
        
        // Trigger the first animation with a delay of 0.5 seconds and execute completion1 when done
        print("dispatch in viewdidload executing...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: completion1)
    }

    func animate(view: UIView, time: Double, soundName: String, completion: @escaping () -> Void) {
        // Animate the view with the specified time
        UIView.animate(withDuration: TimeInterval(time)) {
            print("animate executing...")
            self.playSound(soundName: soundName)
        } completion: { _ in
            // Add the view to the main view after the animation is complete
            self.view.addSubview(view)
            
            // Trigger the completion handler with a delay of 0.3 seconds
            print("dispatch in aniation executing...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: completion)
        }
    }

    func goToAnotherView() {
        // Perform the segue to the next view controller
        performSegue(withIdentifier: "segue", sender: self)
    }

    func playSound(soundName: String){
        // Load and play the specified sound
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }

    
    func makeImageView(imageName: String) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        imageView.image = UIImage(named: imageName)
        return imageView
    }


    
    
}



