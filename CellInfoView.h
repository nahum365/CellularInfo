//
//  CellInfoView.h
//  CellularInfo
//
//  Created by Nahum Getachew on 2/22/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblMain;
@property (weak, nonatomic) IBOutlet UILabel *lblSignal;
@property (weak, nonatomic) IBOutlet UILabel *lblTxAntennas;
@property (weak, nonatomic) IBOutlet UILabel *lblBandwidth;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra1;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra2;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra3;
@property (weak, nonatomic) IBOutlet UILabel *lblExtra4;

- (void)setData:(NSDictionary*)data;

@end
