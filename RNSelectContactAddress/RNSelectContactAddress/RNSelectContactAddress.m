//
//  RNSelectContactAddress.m
//  RNSelectContactAddress
//
//  Created by Ross Haker on 10/22/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import "RNSelectContactAddress.h"

@implementation RNSelectContactAddress

// Expose this module to the React Native bridge
RCT_EXPORT_MODULE()

// Persist data
RCT_EXPORT_METHOD(selectAddress:(BOOL *)boolType
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
    
    // save the resolve promise
    self.resolve = resolve;
    
    // set up an error message
    NSError *error = [
                      NSError errorWithDomain:@"some_domain"
                      code:100
                      userInfo:@{
                                 NSLocalizedDescriptionKey:@"ios8 or higher required"
                                 }];
    
    
    // detect the ios version
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    
    // check that ios is version 8.0 or higher
    if (ver_float < 8.0) {
        
        reject(error);
        
    } else {
        
        ABPeoplePickerNavigationController *picker;
        picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        
        UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [vc presentViewController:picker animated:YES completion:nil];
        
    }
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    // initialize the return fields
    NSString *returnStreet = @"";
    NSString *returnCity = @"";
    NSString *returnState = @"";
    NSString *returnPostal = @"";
    NSString *returnCountry = @"";
    
    // get the address
    if (ABRecordCopyValue(person, kABPersonAddressProperty)) {
        ABMultiValueRef addresses = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonAddressProperty);
        CFDictionaryRef address = ABMultiValueCopyValueAtIndex(addresses, 0);
        
        // set the various address fields
        NSString *street = (NSString*) CFDictionaryGetValue(address, kABPersonAddressStreetKey);
        NSString *city = (NSString*) CFDictionaryGetValue(address, kABPersonAddressCityKey);
        NSString *state = (NSString*) CFDictionaryGetValue(address, kABPersonAddressStateKey);
        NSString *postal = (NSString*) CFDictionaryGetValue(address, kABPersonAddressZIPKey);
        NSString *country = (NSString*) CFDictionaryGetValue(address, kABPersonAddressCountryKey);
        
        // check if values exist
        if (street) {
            returnStreet = street;
        }
        
        // check if values exist
        if (city) {
            returnCity = city;
        }
        
        // check if values exist
        if (state) {
            returnState = state;
        }
        
        // check if values exist
        if (postal) {
            returnPostal = postal;
        }
        
        // check if values exist
        if (country) {
            returnCountry = country;
        }
        
    }
    
    // Set the return dictionary
    NSDictionary *resultsDict = @{
                                  @"street" : returnStreet,
                                  @"city" : returnCity,
                                  @"state" : returnState,
                                  @"postal"  : returnPostal,
                                  @"country"  : returnCountry
                                  };

    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
    
    // resolve the address
    self.resolve(resultsDict);
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc dismissViewControllerAnimated:YES completion:nil];
}

@end
