//
//  Machine.h
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Coin) {
	Quarter = 25,
	Dime = 10,
	Nickel = 5,
	Penny = 1
};

@interface Machine : NSObject

-(NSInteger)getNumberOfInsertedCents;
-(NSInteger)getNumberOfCoinReturnCents;
-(NSString*)getScreenDisplayValue;

-(BOOL)insertCoinWasAccepted:(Coin)coin;
@end
