#import "AppleAuthentication.h"
#import <React/RCTUtils.h>

@implementation AppleAuthentication

-(dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()

-(NSDictionary *)constantsToExport
{
    if (@available(iOS 13.0, *)) {
  NSDictionary* scopes = @{@"FULL_NAME": ASAuthorizationScopeFullName, @"EMAIL": ASAuthorizationScopeEmail};
  NSDictionary* operations = @{
    @"LOGIN": ASAuthorizationOperationLogin,
    @"REFRESH": ASAuthorizationOperationRefresh,
    @"LOGOUT": ASAuthorizationOperationLogout,
    @"IMPLICIT": ASAuthorizationOperationImplicit
  };
  NSDictionary* credentialStates = @{
    @"AUTHORIZED": @(ASAuthorizationAppleIDProviderCredentialAuthorized),
    @"REVOKED": @(ASAuthorizationAppleIDProviderCredentialRevoked),
    @"NOT_FOUND": @(ASAuthorizationAppleIDProviderCredentialNotFound),
  };
  NSDictionary* userDetectionStatuses = @{
    @"LIKELY_REAL": @(ASUserDetectionStatusLikelyReal),
    @"UNKNOWN": @(ASUserDetectionStatusUnknown),
    @"UNSUPPORTED": @(ASUserDetectionStatusUnsupported),
  };
  
  return @{
           @"Scope": scopes,
           @"Operation": operations,
           @"CredentialState": credentialStates,
           @"UserDetectionStatus": userDetectionStatuses
           };
    } else {
        return nil;
    }
}


+ (BOOL)requiresMainQueueSetup
{
  return YES;
}


RCT_EXPORT_METHOD(requestAsync:(NSDictionary *)options
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  _promiseResolve = resolve;
  _promiseReject = reject;
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider* appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        ASAuthorizationAppleIDRequest* request = [appleIDProvider createRequest];
        request.requestedScopes = options[@"requestedScopes"];
        if (options[@"requestedOperation"]) {
        request.requestedOperation = options[@"requestedOperation"];
        }

        ASAuthorizationController* ctrl = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        ctrl.presentationContextProvider = self;
        ctrl.delegate = self;
        [ctrl performRequests];
    }
}

RCT_EXPORT_METHOD(isAvailableAsync:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  if (@available(iOS 13.0, *)) {
    resolve(@(YES));
  } else {
    resolve(@(NO));
  }
}


- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
  return RCTKeyWindow();
}


- (void)authorizationController:(ASAuthorizationController *)controller
   didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
  ASAuthorizationAppleIDCredential* credential = authorization.credential;
  NSDictionary* user = @{
                         @"firstName": RCTNullIfNil(credential.fullName.givenName),
                         @"lastName": RCTNullIfNil(credential.fullName.familyName),
                         @"email": RCTNullIfNil(credential.email),
                         @"user": credential.user,
                         @"authorizedScopes": credential.authorizedScopes,
                         @"realUserStatus": @(credential.realUserStatus),
                         @"state": RCTNullIfNil(credential.state),
                         @"authorizationCode": RCTNullIfNil(credential.authorizationCode),
                         @"identityToken": RCTNullIfNil(credential.identityToken)
                         };
  _promiseResolve(user);
}


-(void)authorizationController:(ASAuthorizationController *)controller
          didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    NSLog(@" Error code%@", error);
  _promiseReject(@"authorization", error.description, error);
}


@end

