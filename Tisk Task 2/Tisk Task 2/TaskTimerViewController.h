//
//  TaskTimerViewController.h
//  Tisk Task 2
//
//  Created by Jordan Zucker on 12/2/11.
//  Copyright (c) 2011 University of Illinois. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskInfo.h"

@interface TaskTimerViewController : UIViewController
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *countdownLabel;
    IBOutlet UIButton *timerButton;
    IBOutlet UILabel *elapsedLabel;
    NSTimer *countdownTimer;
    TaskInfo *taskInfo;
    double timeLeft;
    
}

@property (nonatomic, retain) IBOutlet UILabel *elapsedLabel;
@property (nonatomic, retain) TaskInfo *taskInfo;
@property (nonatomic, retain) NSTimer *countdownTimer;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *countdownLabel;
@property (nonatomic, retain) IBOutlet UIButton *timerButton;

- (IBAction)timerButtonAction:(id)sender;

- (void) startTimer;

- (void) continueTimer;

- (void) stopTimer;

- (void) updateCountdownLabel;

- (void) endTimer;

- (void) setLocalNotification;

@end
