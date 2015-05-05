//
//  ViewController.m
//  JHAnimationKitExample
//
//  Created by Jeff Hurray on 4/29/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import "ViewController.h"
#import "JHAnimationKit.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    self.myView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.myView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.bounds.size.height-50.0, self.view.bounds.size.width, 50.0);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"Action!" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(animateView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void) animateView {
    NSLog(@"In Animate View");
    
    CGRect rect = CGRectMake(100, 100, 150, 20);
    self.myView.moveHeight(30).thenAfter(0.5).moveX(100).thenAfter(0.5).moveHeight(-30).animate(0.5);
    //self.myView.moveX(80).easeInOut.thenAfter(0.5).anchorTopLeft.makeScale(2.0).thenAfter(0.5).anchorTopRight.makeScale(0.5).easeIn.animate(0.3);
    //self.myView.makeFrame(rect).makeBackground([UIColor cyanColor]).easeInOut.animate(1.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
