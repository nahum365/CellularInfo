//
//  ViewController.m
//  CellularInfo
//
//  Created by Nahum Getachew on 2/7/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import "ViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CTCellMonitor.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <dlfcn.h>
#import "CellInfoView.h"
#define SharedAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface ViewController ()
{
    BOOL shouldEx;
    BOOL open;
    NSInteger refreshTime;
}
@end

@implementation ViewController

- (NSArray*)getCurrentTelephonyData
{
    int tmp = 0;
    id CTConnection = _CTServerConnectionCreate(NULL, NULL, NULL);
    NSLog(@"CTConnection: %@", CTConnection);
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(CTConnection, (void*)&tmp, &cells);
    if (cells == NULL)
    {
        NSLog(@"Cells = NULL");
        return 0;
    }
    NSLog(@"Cells = %@", cells);
    NSArray* array = (__bridge NSArray*)cells;
    CFRelease(cells);
    return array;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillLayoutSubviews
{
    for (CALayer* layer in [self.view.layer sublayers])
    {
        if ([layer.name isEqualToString:@"Line"]) [layer removeFromSuperlayer];
    }
    CALayer* layer = [CALayer layer];
    layer.frame = CGRectMake(0.0f, self.scrollView.frame.origin.y, self.view.frame.size.width, 0.5f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.name = @"Line";
    [self.view.layer addSublayer:layer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.tabBarController.tabBar setBarStyle:UIBarStyleBlack];
    
    refreshTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"refreshTime"];
    if (!refreshTime)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"refreshTime"];
        refreshTime = 2;
    }
    
    open = YES;
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    open = NO;
}

- (void)updateUI
{
    
    CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
    self.currentRadioAccess = networkInfo.currentRadioAccessTechnology;
    self.lblCarrier.text = [NSString stringWithFormat:@"Carrier: %@", networkInfo.subscriberCellularProvider.carrierName];
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!self.currentRadioAccess)
    {
        CellInfoView* view = [[CellInfoView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        
        view.lblMain.text = @"No Mobile Data";
        [view.lblMain sizeToFit];
        view.lblSignal.text = @"";
        view.lblTxAntennas.text = @"";
        view.lblBandwidth.text = @"";
        view.lblExtra1.text = @"";
        view.lblExtra2.text = @"";
        view.lblExtra3.text = @"";
        [self.scrollView addSubview:view];
        if (open)[self performSelector:@selector(updateUI) withObject:nil afterDelay:refreshTime];
        return;
    }
    
    NSArray* data = [[[self getCurrentTelephonyData] reverseObjectEnumerator] allObjects];
    NSLog(@"Data: %@", data);
    NSInteger currentYvalue = 0;
    for (NSDictionary* dict in data)
    {
        if ([dict[(__bridge NSString*)kCTCellMonitorCellType] isEqualToString:(__bridge NSString*)kCTCellMonitorCellTypeServing])
        {
            CellInfoView* view = [[CellInfoView alloc] initWithFrame:CGRectMake(0, currentYvalue, self.view.frame.size.width, 100)];
            [view setData:dict];
            [self.scrollView addSubview:view];
            currentYvalue += view.frame.size.height;
        }
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, currentYvalue)];
    self.scrollView.scrollEnabled = YES;
    if (open)[self performSelector:@selector(updateUI) withObject:nil afterDelay:refreshTime];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
