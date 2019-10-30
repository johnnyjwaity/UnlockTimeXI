#include "SBFAuthenticationRequest.h"
#define settingsPath [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.johnnywaity.timeunlockxiprefs.plist"]
//#define settingsPath @"/var/mobile/Library/Preferences/com.johnnywaity.timeunlockxiprefs.plist"
%hook SBFUserAuthenticationController
-(void)processAuthenticationRequest:(id)arg1 {
  //Get Prefs
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  //Load Prefs
  bool enabled = [[prefs objectForKey:@"enabled"] boolValue];
  bool timeMode = [[prefs objectForKey:@"timeMode"] boolValue];
  NSString *userPass = [prefs objectForKey:@"password"];
  bool usePrefix = [[prefs objectForKey:@"usePrefix"] boolValue];
  NSString *extraNums = [prefs objectForKey:@"extraNums"];

  if(!enabled){
    return %orig;
  }

  //Get System Time
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


  //Retrive Passcode entered from parameters
  SBFAuthenticationRequest *req = arg1;
  NSString *pass = req.passcode;

  //Check if password is equal to time
  if([timeString isEqualToString:pass]){
    //Create new AuthRequest with device passcode
    SBFAuthenticationRequest *newReq = [[%c(SBFAuthenticationRequest) alloc] initForPasscode:userPass source: req.source handler: req.handler];
    //Run original with correct password for unlock
    return %orig(newReq);
  }

  //Runs Original with original parameter
  %orig;

}


%end

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
	%orig;

  //Checks User Defaults to see if welcome alert has been shown
  NSString *alertVal = [[NSUserDefaults standardUserDefaults] stringForKey:@"showedTimeUnlockAlert"];




  //stops if it has
  if([alertVal isEqualToString:@"YES"]){
    return;
  }


  //Shows Welcome Alert
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

  //Sets User Default that the alert hasbeen shown
  NSString *valueToSave = @"YES";
  [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"showedTimeUnlockAlert"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

%end



%hook UIStatusBarTimeItemView

-(void)setVisible:(BOOL)arg1 frame:(CGRect)arg2 duration:(double)arg3{
  //Get Prefs
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  //Load Prefs
  bool showTime = [[prefs objectForKey:@"showTime"] boolValue];

  if(showTime){
    //Forces Time To Be Visible
  	arg1 = YES;
  }


	%orig;
}

%end

%hook SBStatusBarStateAggregator
-(void)_updateLockItem {
  //Get Prefs
  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];

  //Load Prefs
  bool showTime = [[prefs objectForKey:@"showTime"] boolValue];
  if(showTime){
    //Removes Status Bar Lock Glyph From StatusBar
  	return;
  }
  else{
    %orig;
  }

}
%end
