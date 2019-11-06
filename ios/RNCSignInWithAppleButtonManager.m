#import <React/RCTViewManager.h>
#import <React/RCTUtils.h>
#import "RNCSignInWithAppleButton.h"
@import AuthenticationServices;

@interface RNSignInWithAppleBlackButton : RCTViewManager @end

@implementation RNSignInWithAppleBlackButton

RCT_EXPORT_MODULE(RNSignInWithAppleBlackButton);

- (UIView *)view
{
  return [[RNCSignInWithAppleButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
}

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

@end

@interface RNSignInWithAppleWhiteButton : RCTViewManager @end

@implementation RNSignInWithAppleWhiteButton

RCT_EXPORT_MODULE(RNSignInWithAppleWhiteButton);

- (UIView *)view
{
  return [[RNCSignInWithAppleButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhite];
}

RCT_EXPORT_VIEW_PROPERTY(onPress, RCTBubblingEventBlock)

@end
