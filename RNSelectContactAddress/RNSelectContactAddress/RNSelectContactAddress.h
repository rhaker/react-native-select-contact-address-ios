//
//  RNSelectContactAddress.h
//  RNSelectContactAddress
//
//  Created by Ross Haker on 10/22/15.
//  Copyright (c) 2015 Facebook. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>
#import <RCTBridge.h>

@interface RNSelectContactAddress : NSObject <RCTBridgeModule, ABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) RCTPromiseResolveBlock resolve;

@end
