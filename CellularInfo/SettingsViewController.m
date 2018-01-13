//
//  SettingsViewController.m
//  CellularInfo
//
//  Created by Nahum Getachew on 2/22/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import "SettingsViewController.h"
#import "dlfcn.h"
#import "RadiosPreferences.h"

@interface SettingsViewController () <UIAlertViewDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table View

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) return @"Settings";
    if (section == 1) return @"Miscellaneous";
    return @"Widget Layout";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) return 3;
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier;
    if (indexPath.section != 2) simpleTableIdentifier  = @"SettingsCell";
    else simpleTableIdentifier = @"WidgetCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Refresh Time";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld seconds", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"refreshTime"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"Font Size (in app)";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"Show LTE Band in Status Bar";
            cell.detailTextLabel.text = @"";
            UISwitch* showBandSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [showBandSwitch addTarget:self action:@selector(showBandChanged:) forControlEvents:UIControlEventValueChanged];
            showBandSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowLTEBandInStatusBar"];
            
            cell.accessoryView = showBandSwitch;
            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"Reset Data Connection";
            cell.detailTextLabel.text = @"JB-Only";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    else if (indexPath.section == 2)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(UIView *subview in cell.contentView.subviews)
            if([subview isKindOfClass:[UILabel class]])
            {
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
                tap.numberOfTapsRequired = 1;
                [(UILabel *)subview addGestureRecognizer:tap];
            }
        return cell;
    }
    return cell;
}

- (void)tapRecognized:(UITapGestureRecognizer*)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Edit Item" message:[NSString stringWithFormat:@"What would you like to replace \"%@\" with?", ((UILabel*)sender.view).text] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"RSRP", @"SNR", @"Type", @"GCI", @"PID", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    
    Item selection;
    switch (buttonIndex)
    {
        case 1:
            selection = ItemRSRP;
            break;
        case 2:
            selection = ItemType;
            break;
        case 3:
            selection = ItemEARFCN;
            break;
        case 4:
            selection = ItemCarrier;
            break;
        case 5:
            selection = ItemRSRP;
            break;
        case 6:
            selection = ItemRSRP;
            break;
        default:
            break;
    }
}

- (void)showBandChanged:(UISwitch*)sender
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring Required" message:@"This is a jailbreak-only feature." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                      {
                          [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"kShowLTEBandInStatusBar"];
                          [[NSUserDefaults standardUserDefaults] synchronize];
                          system("killall SpringBoard");
                      }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
                      {
                          sender.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowLTEBandInStatusBar"];
                      }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Enter Preferred Refresh Time"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField* textField)
             {
                 textField.keyboardType = UIKeyboardTypePhonePad;
                 textField.placeholder = @"Enter a value 0-3600";
             }];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                              {
                                  NSInteger newRefreshTime = ((UITextField*)alert.textFields[0]).text.integerValue;
                                  if (newRefreshTime > 0 && newRefreshTime <= 3600)
                                  {
                                      [[NSUserDefaults standardUserDefaults] setInteger:newRefreshTime forKey:@"refreshTime"];
                                      cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld seconds", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"refreshTime"]];
                                  }
                              }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else if (indexPath.row == 1)
        {
            [[[UIAlertView alloc] initWithTitle:@"This isn't done yet." message:@"It was easier to make this than to remove all the code. ;)" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] show];
            return;
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Enter Preferred Font Size"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField* textField)
             {
                 textField.keyboardType = UIKeyboardTypePhonePad;
                 textField.placeholder = @"Enter a value 0-30";
             }];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                              {
                                  NSInteger newFontSize = ((UITextField*)alert.textFields[0]).text.integerValue;
                                  if (newFontSize > 0 && newFontSize <= 30)
                                  {
                                      [[NSUserDefaults standardUserDefaults] setInteger:newFontSize forKey:@"fontSize"];
                                      cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"]];
                                  }
                              }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            [self toggleAirplane:YES];
            sleep(1);
            [self toggleAirplane:NO];
        }
    }
}

- (void)toggleAirplane:(BOOL)on{
    void* handle = dlopen("/System/Library/PrivateFrameworks/AppSupport.framework/AppSupport", RTLD_NOW);
    Class RadiosPreferences = NSClassFromString(@"RadiosPreferences");
    id instance = [[RadiosPreferences alloc] init];
    [instance setAirplaneMode:on];
    dlclose(handle);
}

@end
