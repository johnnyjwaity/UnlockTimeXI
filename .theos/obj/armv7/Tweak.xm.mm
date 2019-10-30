#line 1 "Tweak.xm"
#include "SBFAuthenticationRequest.h"
#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.johnnywaity.timeunlockxiprefs.plist"]


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBFUserAuthenticationController; @class SBFAuthenticationRequest; @class SBStatusBarStateAggregator; @class SpringBoard; @class UIStatusBarTimeItemView; 
static void (*_logos_orig$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$)(_LOGOS_SELF_TYPE_NORMAL SBFUserAuthenticationController* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$(_LOGOS_SELF_TYPE_NORMAL SBFUserAuthenticationController* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$)(_LOGOS_SELF_TYPE_NORMAL UIStatusBarTimeItemView* _LOGOS_SELF_CONST, SEL, BOOL, CGRect, double); static void _logos_method$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarTimeItemView* _LOGOS_SELF_CONST, SEL, BOOL, CGRect, double); static void (*_logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateLockItem)(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBStatusBarStateAggregator$_updateLockItem(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBFAuthenticationRequest(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBFAuthenticationRequest"); } return _klass; }
#line 4 "Tweak.xm"

static void _logos_method$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$(_LOGOS_SELF_TYPE_NORMAL SBFUserAuthenticationController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
  
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  
  bool enabled = [[prefs objectForKey:@"enabled"] boolValue];
  bool timeMode = [[prefs objectForKey:@"timeMode"] boolValue];
  NSString *userPass = [prefs objectForKey:@"password"];
  bool usePrefix = [[prefs objectForKey:@"usePrefix"] boolValue];
  NSString *extraNums = [prefs objectForKey:@"extraNums"];

  if(!enabled){
    return _logos_orig$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$(self, _cmd, arg1);
  }

  
  NSDate *curDate = [NSDate date];
  NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
  NSString *timeFormat = @"hhmm";
  if(timeMode){
    timeFormat = @"HHmm";
  }
  [outputFormatter setDateFormat:timeFormat];
  NSString *timeString = [outputFormatter stringFromDate:curDate];

  if(usePrefix){
    timeString = [[NSArray arrayWithObjects:extraNums, timeString, nil] componentsJoinedByString:@""];
  }


  
  SBFAuthenticationRequest *req = arg1;
  NSString *pass = req.passcode;

  
  if([timeString isEqualToString:pass]){
    
    SBFAuthenticationRequest *newReq = [[_logos_static_class_lookup$SBFAuthenticationRequest() alloc] initForPasscode:userPass source: req.source handler: req.handler];
    
    return _logos_orig$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$(self, _cmd, newReq);
  }

  
  _logos_orig$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$(self, _cmd, arg1);

}






static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application) {
	_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application);

  
  NSString *alertVal = [[NSUserDefaults standardUserDefaults] stringForKey:@"showedTimeUnlockAlert"];




  
  if([alertVal isEqualToString:@"YES"]){
    return;
  }


  
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You For Installing TimeUnlockXI!"
	message:@"Go To Settings > TimeUnlockXI in order to enable. Please make sure to set the device password also."
	delegate:nil
	cancelButtonTitle:@"Ok!"
	otherButtonTitles:nil];
	[alert show];
	[alert release];

	#pragma clang diagnostic pop

  
  NSString *valueToSave = @"YES";
  [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"showedTimeUnlockAlert"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}







static void _logos_method$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$(_LOGOS_SELF_TYPE_NORMAL UIStatusBarTimeItemView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1, CGRect arg2, double arg3){
  
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  
  bool showTime = [[prefs objectForKey:@"showTime"] boolValue];

  if(showTime){
    
  	arg1 = YES;
  }


	_logos_orig$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$(self, _cmd, arg1, arg2, arg3);
}




static void _logos_method$_ungrouped$SBStatusBarStateAggregator$_updateLockItem(_LOGOS_SELF_TYPE_NORMAL SBStatusBarStateAggregator* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
  
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  
  bool showTime = [[prefs objectForKey:@"showTime"] boolValue];
  if(showTime){
    
  	return;
  }
  else{
    _logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateLockItem(self, _cmd);
  }

}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBFUserAuthenticationController = objc_getClass("SBFUserAuthenticationController"); MSHookMessageEx(_logos_class$_ungrouped$SBFUserAuthenticationController, @selector(processAuthenticationRequest:), (IMP)&_logos_method$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$, (IMP*)&_logos_orig$_ungrouped$SBFUserAuthenticationController$processAuthenticationRequest$);Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);Class _logos_class$_ungrouped$UIStatusBarTimeItemView = objc_getClass("UIStatusBarTimeItemView"); MSHookMessageEx(_logos_class$_ungrouped$UIStatusBarTimeItemView, @selector(setVisible:frame:duration:), (IMP)&_logos_method$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$, (IMP*)&_logos_orig$_ungrouped$UIStatusBarTimeItemView$setVisible$frame$duration$);Class _logos_class$_ungrouped$SBStatusBarStateAggregator = objc_getClass("SBStatusBarStateAggregator"); MSHookMessageEx(_logos_class$_ungrouped$SBStatusBarStateAggregator, @selector(_updateLockItem), (IMP)&_logos_method$_ungrouped$SBStatusBarStateAggregator$_updateLockItem, (IMP*)&_logos_orig$_ungrouped$SBStatusBarStateAggregator$_updateLockItem);} }
#line 133 "Tweak.xm"
