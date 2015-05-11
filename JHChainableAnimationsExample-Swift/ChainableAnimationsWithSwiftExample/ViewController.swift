//
//  ViewController.swift
//  ChainableAnimationsWithSwiftExample
//
//  Created by Jeff Hurray on 5/11/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var myView : UIView = UIView();
 
    init() {
        super.init(nibName: nil, bundle: nil);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.myView.frame = CGRect(x: 100, y: 150, width: 50, height: 50);
        self.myView.backgroundColor = UIColor.blueColor();
        self.view.addSubview(self.myView);
        
        var button : UIButton = UIButton(frame: CGRect(x: 0, y: self.view.bounds.size.height-50.0, width: self.view.bounds.size.width, height: 50.0));
        button.backgroundColor = UIColor.blueColor();
        button.setTitle("Action!", forState: .Normal);
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal);
        button.addTarget(self, action: "animateView:", forControlEvents: .TouchUpInside);
        self.view.addSubview(button);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func animateView (sender: UIButton) {
        sender.userInteractionEnabled = false;
        
        self.myView.animationCompletion = {
            self.myView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            self.myView.frame = CGRect(x: 100, y: 150, width: 50, height: 50);
            self.myView.makeOpacity()(1.0).makeBackground()(UIColor.blueColor()).animate()(1.5);
            sender.userInteractionEnabled = true;
        };
        
        let purple : UIColor = UIColor.purpleColor();
        self.myView.moveWidth()(50).bounce().makeBackground()(purple).easeIn().anchorTopLeft()
            .thenAfter()(0.8).rotate()(95).easeBack().wait()(0.2)
            .thenAfter()(0.5).moveY()(300).easeIn().makeOpacity()(0.0).animate()(0.4);
    }

}

