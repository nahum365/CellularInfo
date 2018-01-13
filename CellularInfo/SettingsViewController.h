//
//  SettingsViewController.h
//  CellularInfo
//
//  Created by Nahum Getachew on 2/22/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController
typedef NS_ENUM(NSInteger, Item) {
    ItemRSRP,
    ItemType,
    ItemEARFCN,
    ItemCarrier,
    ItemBW,
    ItemCellID
};
@end
