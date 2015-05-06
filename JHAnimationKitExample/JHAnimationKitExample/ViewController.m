//
//  ViewController.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import "ViewController.h"
#import "JHAnimationKit.h"
#import "JHKeyframeAnimation.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(150, 50, 50, 50)];
    self.myView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.bounds.size.height-50.0, self.view.bounds.size.width, 50.0);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Action!" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(animateView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void) animateView:(UIButton *)sender {
    NSLog(@"In Animate View");
    
//    sender.userInteractionEnabled = NO;
//    
//    __weak ViewController *weakSelf = self;
//    self.myView.animationCompletion = JHAnimationCompletion() {
//        weakSelf.myView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
//        weakSelf.myView.frame = CGRectMake(150, 50, 50, 50);
//        weakSelf.myView.makeOpacity(1.0).animate(1.5);
//        sender.userInteractionEnabled = YES;
//    };
//    
//    self.myView.moveWidth(50).bounce.anchorTopLeft.
//        thenAfter(0.8).rotate(95).easeBack.wait(0.2).
//        thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animate(0.4);
    
    self.myView.movePolar(20, 90).animate(1.0);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
