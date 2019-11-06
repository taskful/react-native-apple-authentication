import React from 'react';
import { NativeModules, requireNativeComponent ,Platform } from 'react-native';

const { AppleAuthentication } = NativeModules;

export const SignInWithAppleWhiteButton = requireNativeComponent('RNSignInWithAppleWhiteButton');

export const SignInWithAppleBlackButton = requireNativeComponent('RNSignInWithAppleWhiteButton');

export const SignInWithAppleButton = (style, buttonStyle, callBack) => {
  if(Platform.OS === 'ios'){
    const Button = buttonStyle === "black" ? SignInWithAppleBlackButton : SignInWithAppleWhiteButton;
    return <Button style={style} onPress={async () => {
    
        await AppleAuthentication.requestAsync({
          requestedScopes: [AppleAuthentication.Scope.FULL_NAME, AppleAuthentication.Scope.EMAIL],
          requestedOperation: AppleAuthentication.Operation.LOGIN,
        }).then((response) => {
          callBack(response) //Display response
          }, (error) => {
            callBack(error) //Display error
           
        });

  }} />
  }else{
  return null

  }
   
}

export default AppleAuthentication;
