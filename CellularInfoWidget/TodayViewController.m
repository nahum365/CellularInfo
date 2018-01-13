//
//  TodayViewController.m
//  CellularInfoWidget
//
//  Created by Nahum Getachew on 2/7/15.
//  Copyright (c) 2015 Nahum Getachew. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "CTCellMonitor.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <dlfcn.h>

@interface TodayViewController () <NCWidgetProviding>
{
    
}
@end

@implementation TodayViewController

typedef void (^BlockCallback)(NSDictionary*);

- (NSDictionary*)getCurrentTelephonyData
{
    NSDictionary* dict;
    
    int tmp = 0;
    id CTConnection = _CTServerConnectionCreate(NULL, NULL, NULL);
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(CTConnection, (void*)&tmp, &cells);
    if (cells == NULL)
    {
        return 0;
    }
    for (NSDictionary* cell in (__bridge NSArray*)cells)
    {
        if ([cell[(__bridge NSString*)kCTCellMonitorCellType] isEqualToString:(__bridge NSString*)kCTCellMonitorCellTypeServing])
        {
            dict = cell;
        }
    }
    
    CFRelease(cells);
    return dict;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
    NSString* currentRadioAccess = telephonyInfo.currentRadioAccessTechnology;
    self.lblMain.text = [currentRadioAccess componentsSeparatedByString:@"CTRadioAccessTechnology"][1];
    self.lblCarrier.text = telephonyInfo.subscriberCellularProvider.carrierName;
    
    NSDictionary* data = [self getCurrentTelephonyData];
    if (!currentRadioAccess)
    {
        self.lblMain.text = @"No Mobile Data";
        [self.lblMain sizeToFit];
        self.lblSignal.text = @"";
        self.lblTxAntennas.text = @"";
        self.lblBandwidth.text = @"";
        self.lblExtra1.text = @"";
        self.lblExtra2.text = @"";
        self.lblExtra3.text = @"";
    }
    else if (currentRadioAccess == CTRadioAccessTechnologyCDMA1x)
    {
        void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
        int (*CTGetSignalStrength)();
        CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength");
        if( CTGetSignalStrength == NULL) NSLog(@"Could not find CTGetSignalStrength");
        int result = CTGetSignalStrength();
        int dBm = 0;
        if(result <= 0)
            dBm = -100;
        else if(result >= 100)
            dBm = -50;
        else
            dBm = (result / 2) - 100;
        
        self.lblSignal.text = [NSString stringWithFormat:@"RSSI: %d dBm", dBm];
        dlclose(libHandle);
        self.lblTxAntennas.text = [NSString stringWithFormat:@"Channel #: %@", data[(__bridge __strong id)(kCTCellMonitorChannelNumber)]];
        NSString* bandClass;
        switch ([data[(__bridge __strong id)(kCTCellMonitorBandClass)] integerValue])
        {
            case 0:
                bandClass = @"800";
                break;
            case 1:
                bandClass = @"1900 PCS";
                break;
            case 2:
                bandClass = @"TACS";
                break;
            case 3:
                bandClass = @"JTACS";
                break;
            case 4:
                bandClass = @"Korean PCS";
                break;
            case 5:
                bandClass = @"450";
                break;
            case 6:
                bandClass = @"2 Ghz";
                break;
            case 7:
                bandClass = @"Upper 700 Mhz";
                break;
            case 8:
                bandClass = @"1800";
                break;
            case 9:
                bandClass = @"900";
                break;
            case 10:
                bandClass = @"Secondary 800 Mhz";
                break;
            default:
                bandClass = data[(__bridge __strong id)(kCTCellMonitorBandClass)];
                break;
        }
        self.lblBandwidth.text = [NSString stringWithFormat:@"Band Class: %@", bandClass];
        
        self.lblExtra1.text = [NSString stringWithFormat:@"SID: %@", data[(__bridge __strong id)(kCTCellMonitorSID)]];
        self.lblExtra2.text = [NSString stringWithFormat:@"BID: %@", data[(__bridge __strong id)(kCTCellMonitorBaseStationId)]];
        
    }
    else if (currentRadioAccess == CTRadioAccessTechnologyCDMAEVDORev0 || currentRadioAccess == CTRadioAccessTechnologyCDMAEVDORevA || currentRadioAccess == CTRadioAccessTechnologyCDMAEVDORevB || currentRadioAccess == CTRadioAccessTechnologyeHRPD)
    {
        CTTelephonyNetworkInfo* networkInfo = [CTTelephonyNetworkInfo new];
        if (networkInfo.currentRadioAccessTechnology == CTRadioAccessTechnologyeHRPD)
        {
            self.lblMain.text = @"eHRPD";
        }
        void *libHandle = dlopen("/System/Library/Frameworks/CoreTelephony.framework/CoreTelephony", RTLD_LAZY);
        int (*CTGetSignalStrength)();
        CTGetSignalStrength = dlsym(libHandle, "CTGetSignalStrength");
        if( CTGetSignalStrength == NULL) NSLog(@"Could not find CTGetSignalStrength");
        int result = CTGetSignalStrength();
        int dBm = 0;
        if(result <= 0)
            dBm = -100;
        else if(result >= 100)
            dBm = -50;
        else
            dBm = (result / 2) - 100;
        
        self.lblSignal.text = [NSString stringWithFormat:@"RSSI: %d dBm", dBm];
        dlclose(libHandle);
        
        self.lblTxAntennas.text = [NSString stringWithFormat:@"Channel #: %@", data[(__bridge __strong id)(kCTCellMonitorChannelNumber)]];
        
        NSString* bandClass;
        switch ([data[(__bridge __strong id)(kCTCellMonitorBandClass)] integerValue])
        {
            case 0:
                bandClass = @"800";
                break;
            case 1:
                bandClass = @"1900 PCS";
                break;
            case 2:
                bandClass = @"TACS";
                break;
            case 3:
                bandClass = @"JTACS";
                break;
            case 4:
                bandClass = @"Korean PCS";
                break;
            case 5:
                bandClass = @"450";
                break;
            case 6:
                bandClass = @"2 Ghz";
                break;
            case 7:
                bandClass = @"Upper 700 Mhz";
                break;
            case 8:
                bandClass = @"1800";
                break;
            case 9:
                bandClass = @"900";
                break;
            case 10:
                bandClass = @"Secondary 800 Mhz";
            default:
                bandClass = data[(__bridge __strong id)(kCTCellMonitorBandClass)];
                break;
        }
        self.lblBandwidth.text = [NSString stringWithFormat:@"Band Class: %@", bandClass];
        self.lblExtra1.text = [NSString stringWithFormat:@"MCC: %@", data[(__bridge __strong id)(kCTCellMonitorMCC)]];
        self.lblExtra2.text = [NSString stringWithFormat:@"PN Offset: %@", data[(__bridge __strong id)(kCTCellMonitorPNOffset)]];
    }
    else if (currentRadioAccess == CTRadioAccessTechnologyLTE)
    {
        self.lblMain.text = [NSString stringWithFormat:@"LTE: Band %@", data[(__bridge __strong id)(kCTCellMonitorBandInfo)]];
        self.lblSignal.text = [NSString stringWithFormat:@"RSRP: %@ dBm", data[(__bridge __strong id)(kCTCellMonitorRSRP)]];
        self.lblTxAntennas.text = [NSString stringWithFormat:@"SNR: %@ dB", data[(__bridge __strong id)(kCTCellMonitorSNR)]];
        int bw = [data[(__bridge __strong id)(kCTCellMonitorBandwidth)] intValue];
        
        if ([data[(__bridge __strong id)(kCTCellMonitorBandInfo)] isEqual:@41])
        {
            if ([data[(__bridge __strong id)(kCTCellMonitorMCC)] isEqual:@310] && [data[(__bridge __strong id)(kCTCellMonitorMNC)] isEqual:@120])
            {
                self.lblBandwidth.text = @"Type: TDD 1x20 MHz (Sprint)";
            }
            else self.lblBandwidth.text = @"Type: TDD 1x20 MHz (Clear)";
        }
        else self.lblBandwidth.text = [NSString stringWithFormat:@"Type: FDD %dx%d MHz", bw / 5, bw / 5];
        
        id CTConnection = _CTServerConnectionCreate(NULL, NULL, NULL);
        int CID;
        _CTServerConnectionGetCellID(CTConnection, &CID);
        
        NSString* CIDstring = [NSString stringWithFormat:@"%X", CID];
        
        NSInteger length = CIDstring.length;
        
        if (length < 8)
        {
            for (NSInteger i = length; i < 8; i++) CIDstring = [@"0" stringByAppendingString:CIDstring];
        }
        
        self.lblExtra1.text = [NSString stringWithFormat:@"GCI: %@", CIDstring];
        self.lblExtra2.text = [NSString stringWithFormat:@"PID: %@", data[(__bridge __strong id)(kCTCellMonitorPID)]];
        self.lblExtra3.text = [NSString stringWithFormat:@"UARFCN: %@", data[(__bridge __strong id)(kCTCellMonitorUARFCN)]];
    }
    else
    {
        self.lblSignal.text = @"";
        self.lblTxAntennas.text = @"";
        self.lblBandwidth.text = @"";
        self.lblExtra1.text = @"Unknown Connection Type";
        self.lblExtra2.text = @"";
        self.lblExtra3.text = @"";
    }
    if (open)[self performSelector:@selector(updateUI) withObject:nil afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"refreshTime"]];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    [self updateUI];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.left = 0;
    margins.right = 0;
    margins.bottom = 2;
    return margins;
}


- (IBAction)openSignalCheckPressed:(id)sender
{
    [self.extensionContext openURL:[NSURL URLWithString:@"cellularinfo://"] completionHandler:nil];
    
}

@end
