//
//  RRFLoginViewController.m
//  RRFLogin
//
//  Created by Rob Fahrni on 10/5/14.
//  Copyright (c) 2014 Apple Core Labs. All rights reserved.
//
#import "RRFLoginViewController.h"

// The keyboard is a wee bit tall, let's take a bit off of our calculation.
//CGFloat const kRRFKeyboardFudge = 20;

@interface RRFLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonHandler:(id)sender;

// State info
@property (assign, nonatomic) BOOL rrf_keyboardIsShowing;
@end

@implementation RRFLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set the nice looking background
    UIImage* backgroundImage = [UIImage imageNamed:((IS_IPHONE5) ? kRRFLaunchR4 : kRRFLaunch2x)];
    self.view.layer.contents = (id)backgroundImage.CGImage;
    
    // Get keyboard notifications so we can move the view up in response
    // to the keyboard showing.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)loginButtonHandler:(id)sender
{
    NSString* userName = self.userNameTextField.text;
    if (IsEmpty(userName)) {
        [self rrf_displayErrorMessage:kRRFUserNameRequiredMessage];
        return;
    }
    
    NSString* password = self.passwordTextField.text;
    if (IsEmpty(password)) {
        [self rrf_displayErrorMessage:kRRFPasswordRequiredMessage];
        return;
    }
    
    // Ok, good to go.
    [[RRFHTTPClient shared] loginUser:userName
                             password:password
                              success:^{
                                  [self rrf_displaySuccessMessage:RRFLoadString(kRRFLoginSucceeded)];
                              } failure:^(NSDictionary *errorDictionary) {
                                  [self rrf_displayErrorMessage:RRFLoadString(kRRFLoginFailed)];
                              }];
    
}

#pragma mark - Actions

- (void)touchesBegan:(NSSet*)touches
           withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification*)notif
{
    if (self.rrf_keyboardIsShowing) {
        [UIView animateWithDuration:0.3 animations:^{
            CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            CGRect frame = self.containerView.frame;
            frame.origin.y += (keyboardSize.height-([UIApplication sharedApplication].statusBarFrame.size.height*2));
            self.containerView.frame = frame;
        } completion:^(BOOL finished) {
            self.rrf_keyboardIsShowing = NO;
        }];
    }
}

- (void)keyboardWillShow:(NSNotification*)notif
{
    if (NO == self.rrf_keyboardIsShowing) {
        [UIView animateWithDuration:0.3 animations:^{
            CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            CGRect frame = self.containerView.frame;
            frame.origin.y -= (keyboardSize.height-([UIApplication sharedApplication].statusBarFrame.size.height*2));
            self.containerView.frame = frame;
        } completion:^(BOOL finished) {
            self.rrf_keyboardIsShowing = YES;
        }];
    }
}

#pragma mark - Private Methods

- (void)rrf_displayMessageWith:(NSString*)title andMessage:(NSString*)message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:RRFLoadString(kRRFOkTitle)
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)rrf_displaySuccessMessage:(NSString*)message
{
    [self rrf_displayMessageWith:RRFLoadString(kRRFLoginApp) andMessage:message];
}

- (void)rrf_displayErrorMessage:(NSString*)message
{
    [self rrf_displayMessageWith:RRFLoadString(kRRFError) andMessage:message];
}

@end
