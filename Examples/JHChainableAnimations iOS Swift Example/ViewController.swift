//
//  ViewController.swift
//  JHChainableAnimations iOS Swift Example
//
//  Created by Jeff Hurray on 1/22/17.
//  Copyright © 2017 jhurray. All rights reserved.
//

import UIKit
import ChainableAnimations

class ViewController: UIViewController {

    let myView = UIView(frame: CGRect(x: 100, y: 150, width: 50, height: 50))
    let button: UIButton = UIButton(type: .custom)
    let pauseButton: UIButton = UIButton(type: .custom)
    var animator: ChainableAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myView.backgroundColor = .blue
        view.addSubview(myView)
        
        button.backgroundColor = .blue
        button.setTitle("Action!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: view.bounds.height-50, width: view.bounds.width, height: 50)
        button.addTarget(self, action: #selector(animateView), for: .touchUpInside)
        view.addSubview(button)
        
        pauseButton.backgroundColor = .blue
        pauseButton.setTitle("Pause", for: .normal)
        pauseButton.setTitleColor(.white, for: .normal)
        pauseButton.frame = CGRect(x: 16, y: 32, width: 100, height: 50)
        pauseButton.addTarget(self, action: #selector(pauseSelected), for: .touchUpInside)
        view.addSubview(pauseButton)
        
        animator = ChainableAnimator(view: myView)
    }
    
    func pauseSelected() {
        guard let animator = animator else {
            return
        }
        if !animator.isPaused {
            pauseButton.setTitle("Resume", for: .normal)
            animator.pause()
        }
        else {
            pauseButton.setTitle("Pause", for: .normal)
            animator.resume()
        }
    }
    
    func animateView() {
        
        guard let animator = animator else {
            return
        }
        
        button.isUserInteractionEnabled = false
        let buttonAnimator = ChainableAnimator(view: button)
        
        animator.completion = { [unowned self] in
            self.myView.layer.transform = CATransform3DIdentity
            self.myView.frame = CGRect(x: 100, y: 150, width: 50, height: 50)
            self.animator?.transformIdentity.makeOpacity(alpha: 1).makeBackground(color: .blue).animate(t: 1.0)
            buttonAnimator.moveY(y: -50).easeInOutExpo.animateWithCompletion(t: 1.1, completion: {
                self.button.isUserInteractionEnabled = true
            })
        }
        
        buttonAnimator.moveY(y: 50).easeInOutExpo.animate(t: 0.5)
        
        animator.moveWidth(width: 30).bounce.makeBackground(color: .purple).easeIn.anchorTopLeft
            .repeatAnimation(t: 0.5, count: 3).rotateZ(angle: 95).easeBack.wait(t: 0.2)
            .thenAfter(t: 0.5).moveY(y: 300).easeIn.makeOpacity(alpha: 0.0).animate(t: 0.4);
        
    }
}

