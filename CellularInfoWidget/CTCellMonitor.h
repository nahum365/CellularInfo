//
//  CTCellMonitor.h
//  BandInfo
//
//  Created by Nahum Getachew on 1/22/15.
//
//

struct CTResult
{
    int flag;
    int a;
};

extern CFStringRef const kCTCellMonitorCellType;
extern CFStringRef const kCTCellMonitorCellTypeServing;
extern CFStringRef const kCTCellMonitorCellTypeNeighbor;
extern CFStringRef const kCTCellMonitorCellId;
extern CFStringRef const kCTCellMonitorLAC;
extern CFStringRef const kCTCellMonitorMCC;
extern CFStringRef const kCTCellMonitorMNC;
extern CFStringRef const kCTCellMonitorBandInfo;
extern CFStringRef const kCTCellMonitorBandClass;
extern CFStringRef const kCTCellMonitorPNOffset;
extern CFStringRef const kCTCellMonitorRSRP;
extern CFStringRef const kCTCellMonitorChannelNumber;
extern CFStringRef const kCTCellMonitorSectorId;
extern CFStringRef const kCTCellMonitorTAC;
extern CFStringRef const kCTCellMonitorBandwidth;
extern CFStringRef const kCTCellMonitorUARFCN;
extern CFStringRef const kCTCellMonitorCellRadioAccessTechnology;
extern CFStringRef const kCTCellMonitorNID;
extern CFStringRef const kCTCellMonitorSNR;
extern CFStringRef const kCTCellMonitorPID;
extern CFStringRef const kCTCellMonitorSID;
extern CFStringRef const kCTCellMonitorBaseStationId;
extern CFStringRef const kCTRegistrationCellChangedNotification;
extern CFStringRef const kCTRegistrationCellId;

id CTTelephonyCenterGetDefault();
void CTTelephonyCenterAddObserver(id, void*, CFNotificationCallback, CFStringRef, void*, CFNotificationSuspensionBehavior);

extern CFStringRef const kCTCellMonitorUpdateNotification;

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);
void _CTServerConnectionAddToRunLoop(id, CFRunLoopRef, CFStringRef);
int CellMonitorCallback(id connection, CFStringRef string, CFDictionaryRef dictionary, void *data);

#ifdef __LP64__

void _CTServerConnectionRegisterForNotification(id, CFStringRef);
void _CTServerConnectionCellMonitorStart(id);
void _CTServerConnectionCellMonitorStop(id);
void _CTServerConnectionCellMonitorCopyCellInfo(id, void*, CFArrayRef*);


#else

void _CTServerConnectionRegisterForNotification(struct CTResult*, id, CFStringRef);
#define _CTServerConnectionRegisterForNotification(connection, notification) { struct CTResult res; _CTServerConnectionRegisterForNotification(&res, connection, notification); }

void _CTServerConnectionCellMonitorStart(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStart(connection) { struct CTResult res; _CTServerConnectionCellMonitorStart(&res, connection); }

void _CTServerConnectionCellMonitorStop(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStop(connection) { struct CTResult res; _CTServerConnectionCellMonitorStop(&res, connection); }

void _CTServerConnectionCellMonitorCopyCellInfo(struct CTResult*, id, void*, CFArrayRef*);
#define _CTServerConnectionCellMonitorCopyCellInfo(connection, tmp, cells) { struct CTResult res; _CTServerConnectionCellMonitorCopyCellInfo(&res, connection, tmp, cells); }

#endif

#ifdef __LP64__

void _CTServerConnectionGetCellID(id, int*);

#else

void _CTServerConnectionGetCellID(struct CTResult*, id, int*);
#define _CTServerConnectionGetCellID(connection, CID) { struct CTResult res; _CTServerConnectionGetCellID(&res, connection, CID); }

#endif


