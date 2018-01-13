//
//  ViewController.h
//  CellularInfo
//
//  Created by Nahum Getachew on 2/7/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, Item) {
    ItemRSRP,
    ItemType,
    ItemEARFCN,
    ItemCarrier,
    ItemBW,
    ItemCellID
};

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblCarrier;

@property (strong, nonatomic) NSString* currentRadioAccess;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)updateUI;
- (NSArray*)getCurrentTelephonyData;

@end

