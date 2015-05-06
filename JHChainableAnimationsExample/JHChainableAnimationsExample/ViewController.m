//
//  ViewController.m
//  JHChainableAnimationsExample
//
//  Created by Jeff Hurray on 5/6/15.
//  Copyright (c) 2015 jhurray. All rights reserved.
//

#import "JHChainableAnimations.h"
#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myView = [[UIView alloc] initWithFrame:CGRectMake(100, 150, 50, 50)];
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
    
    sender.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:1.0
                        options:0 animations:^{
                            CGPoint newPosition = self.myView.layer.position;
                            newPosition.x += 50;
                            self.myView.layer.position = newPosition;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            self.myView.backgroundColor = [UIColor purpleColor];
        } completion:nil];
    }];
    
    self.myView.moveX(50).thenAfter(1.0).makeBackground([UIColor purpleColor]).easeIn.animate(0.5);
    
    
    __weak ViewController *weakSelf = self;
    self.myView.animationCompletion = JHAnimationCompletion() {
        weakSelf.myView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        weakSelf.myView.frame = CGRectMake(150, 50, 50, 50);
        weakSelf.myView.makeOpacity(1.0).animate(1.5);
        sender.userInteractionEnabled = YES;
    };
    
    UIColor *purple = [UIColor purpleColor];
    self.myView.moveWidth(50).bounce.makeBackground(purple).easeIn.anchorTopLeft.
        thenAfter(0.8).rotate(95).easeBack.wait(0.2).
        thenAfter(0.5).moveY(300).easeIn.makeOpacity(0.0).animate(0.4);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
