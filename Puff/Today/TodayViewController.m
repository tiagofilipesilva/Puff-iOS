//
//  TodayViewController.m
//  Today
//
//  Created by bob.sun on 18/11/2016.
//  Copyright © 2016 bob.sun. All rights reserved.
//

#import "TodayViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <NotificationCenter/NotificationCenter.h>

#include "Constants.h"
#import "PFResUtil.h"
#import "PFSettings.h"

#define txtNoAccountInfo                NSLocalizedString(@"No Account Infomation", nil)
#define txtAccountName                  NSLocalizedString(@"Click button to copy information", nil)

@interface TodayViewController () <NCWidgetProviding>
@property (weak, nonatomic) IBOutlet UIButton *btnAccount;
@property (weak, nonatomic) IBOutlet UIButton *btnPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnAdditional;
@property (weak, nonatomic) IBOutlet UIView *btnWrapper;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) NSUserDefaults *store;
@property (strong, nonatomic) NSString * account;
@property (strong, nonatomic) NSString * password;
@property (strong, nonatomic) NSString * additional;
@property (strong, nonatomic) NSString * icon;
@property (assign, nonatomic) BOOL needClear;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    // Do any additional setup after loading the view from its nib.
    _store = [[NSUserDefaults alloc] initWithSuiteName:kUserDefaultGroup];
}

//- (void)widgetActiveDisplayMwodeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
//    self.preferredContentSize = CGSizeMake(0, 50);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    _account = [_store objectForKey:kTodayAccount];
    _password = [_store objectForKey:kTodayPassword];
    _additional = [_store objectForKey:kTodayAdditional];
    _icon = [_store objectForKey:kTodayIcon];
    
    if (_icon.length > 0) {
        _iconImage.image = [PFResUtil imageForName:_icon];
    } else {
        _iconImage.image = [UIImage imageNamed:@"icon-puff"];
    }
    
    _needClear = [[PFSettings sharedInstance] clearInfo];
    
    if (_account.length == 0 && _password.length == 0 && _additional.length == 0) {
        _hintLabel.text = txtNoAccountInfo;
    } else {
        _hintLabel.text = txtAccountName;
    }
    
    if ([_store boolForKey:kTodayNewData]) {
        [_store setBool:NO forKey:kTodayNewData];
        [_store synchronize];
        completionHandler(NCUpdateResultNewData);
    } else {
        completionHandler(NCUpdateResultNoData);
    }
}
- (IBAction)didTapOnAccount:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if (_account.length == 0) {
        [board setString:@""];
        return;
    }
    [board setString:_account];
    if (_needClear) {
        [_store setObject:@"" forKey:kTodayAccount];
        [_store synchronize];
    }
}
- (IBAction)didTapOnPassword:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if (_password.length == 0) {
        [board setString:@""];
        return;
    }
    [board setString:_password];
    if (_needClear) {
        [_store setObject:@"" forKey:kTodayPassword];
        [_store synchronize];
    }
}

- (IBAction)didTapOnAdditional:(id)sender {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if (_additional.length == 0) {
        [board setString:@""];
        return;
    }
    [board setString:_additional];
    if (_needClear) {
        [_store setObject:@"" forKey:kTodayAdditional];
        [_store synchronize];
    }
}

@end
