//
//  TodayViewController.h
//  CellularInfoWidget
//
//  Created by Nahum Getachew on 2/7/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblMain;
@property (weak, nonatomic) IBOutlet UILabel *lblSignal;
@property (weak, nonatomic) IBOutlet UILabel *lblTxAntennas;
@property (weak, nonatomic) IBOutlet UILabel *lblBandwidth;
@property (weak, nonatomic) IBOutlet UILabel *lblCarrier;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra1;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra2;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra3;
- (IBAction)openSignalCheckPressed:(id)sender;

@end
