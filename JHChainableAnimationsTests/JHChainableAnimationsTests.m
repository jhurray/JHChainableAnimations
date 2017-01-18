//
//  JHChainableAnimationsTests.m
//  JHChainableAnimationsTests
//
//  Created by Jeff Hurray on 12/21/16.
//  Copyright © 2016 jhurray. All rights reserved.
//

#import <XCTest/XCTest.h>
@import JHChainableAnimations;


#import "JHChainableAnimator.h"
#import "JHAnimationChainLink.h"

typedef NS_ENUM(NSInteger, JHChainableAnimatorContinuationMode) {
    JHChainableAnimatorContinuationModeContinue,
    JHChainableAnimatorContinuationModePause,
    JHChainableAnimatorContinuationModeStop,
};

@interface JHChainableAnimator (JH_Test)

@property (nonatomic, weak) UIView *view;
@property (strong, nonatomic) NSMutableArray<JHAnimationChainLink *> *animationChainLinks;
@property (strong, nonatomic) NSMapTable<JHAnimationChainLink *, NSNumber *> *animationDurationMapping;
@property (atomic, assign, getter=isAnimating) BOOL animating;
@property (atomic, assign, getter=isPaused) BOOL paused;
@property (nonatomic, assign) JHChainableAnimatorContinuationMode continuationMode;
@property (nonatomic, readonly) JHAnimationChainLink *currentAnimationLink;

@end


@interface JHChainableAnimationsTests : XCTestCase

@property (nonatomic, strong) UIView *superView;
@property (nonatomic, strong) JHChainableAnimator *animator;
@property (nonatomic, weak, readonly) JHChainableAnimator *weakAnimator;

@end

#define kDuration 0.01

@implementation JHChainableAnimationsTests

- (__weak JHChainableAnimator *)weakAnimator
{
    __weak JHChainableAnimator *weakAnimator = self.animator;
    return weakAnimator;
}


- (void)setUp
{
    [super setUp];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIView *superView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [superView addSubview:view];
    self.superView = superView;
    JHChainableAnimator *animator = [[JHChainableAnimator alloc] initWithView:view];
    self.animator = animator;
}


- (void)tearDown
{
    [self.animator.view removeFromSuperview];
    [super tearDown];
}


- (void)testWithBlock:(void(^)(void(^finished)()))block
{
    static NSString * const kJHTestDescription = @"JHTest";
    XCTestExpectation *expectation = [self expectationWithDescription:kJHTestDescription];
    block(^{
        [expectation fulfill];
    });
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}


- (void)testMoveX
{
    [self testWithBlock:^(void (^finished)(void)) {
        self.animator.moveX(20).animateWithCompletion(kDuration, ^{
            XCTAssertEqual(self.weakAnimator.view.frame.origin.x, 20);
            finished();
        });
    }];
}


- (void)testMakeX
{
    [self testWithBlock:^(void (^finished)(void)) {
        self.animator.makeX(50).animateWithCompletion(kDuration, ^{
            XCTAssertEqual(self.weakAnimator.view.frame.origin.x, 50);
            finished();
        });
    }];
}


- (void)testContinuationMode
{
    XCTAssertEqual(self.animator.continuationMode, JHChainableAnimatorContinuationModeContinue);
    [self testWithBlock:^(void (^finished)(void)) {
        self.animator.moveX(10).easeIn.thenAfter(kDuration).makeSize(12, 12).preAnimationBlock(^{
            XCTAssertEqual(self.weakAnimator.continuationMode, JHChainableAnimatorContinuationModeContinue);
            [self.weakAnimator pause];
        }).thenAfter(kDuration).makeSize(12, 12).preAnimationBlock(^{
            XCTFail(@"Shouldnt reach here");
        }).animate(kDuration);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssertEqual(self.weakAnimator.continuationMode, JHChainableAnimatorContinuationModePause);
            XCTAssertTrue(self.animator.isAnimating);
            XCTAssertTrue(self.animator.isPaused);
            finished();
        });
    }];
}


- (void)testResume
{
    [self testWithBlock:^(void (^finished)(void)) {
        self.animator.moveX(10).easeIn.thenAfter(kDuration).makeSize(12, 12).preAnimationBlock(^{
            [self.weakAnimator pause];
        }).thenAfter(kDuration).makeSize(12, 12).animateWithCompletion(kDuration, ^{
            XCTAssertTrue(self.animator.isAnimating);
            XCTAssertFalse(self.animator.isPaused);
            finished();
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDuration * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            XCTAssertTrue(self.animator.isAnimating);
            XCTAssertTrue(self.animator.isPaused);
            [self.animator resume];
        });
    }];
}

@end
