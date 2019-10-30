#include "XXXRootListController.h"

@implementation XXXRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
-(void)openTwitter{
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/johnnywaity"]];
}
-(void)openPaypal{
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.paypal.me/johnnywaity"]];
}
-(void)openGithub{
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/johnnyjwaity/UnlockTimeXI/issues"]];
}

@end
