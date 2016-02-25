//
//  Machine.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import "Machine.h"

@interface Machine ()
//for tracking how many cents are "inserted"
@property (nonatomic, assign) NSInteger numberOfInsertedCents;

//for tracking the number of cents in the coin return
@property (nonatomic, assign) NSInteger numberOfCoinReturnCents;
@end


@implementation Machine

-(NSInteger)getNumberOfInsertedCents {
	return self.numberOfInsertedCents;
}

-(NSInteger)getNumberOfCoinReturnCents {
	return self.numberOfCoinReturnCents;
}

-(NSString *)getScreenDisplayValue {
	return @"";
}

// Returns whether or not the inserted coin was accepted or not
-(BOOL)insertCoinWasAccepted:(Coin)coin {
	
	//if a Penny (currently the only rejected Coin) is inserted...
	if (coin == Penny) {
		//...reject it, and add the Penny's worth to the coin return
		self.numberOfCoinReturnCents += Penny;
		return NO;
	}
	
	self.numberOfInsertedCents += coin;
	
	return YES;
}

@end
