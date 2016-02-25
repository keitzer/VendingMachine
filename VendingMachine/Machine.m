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
	if (self.numberOfInsertedCents == 0) {
		return @"INSERT COIN";
	}
	
	NSInteger cents = self.numberOfInsertedCents % 100;
	NSString *centString;
	if (cents < 10) {
		centString = [NSString stringWithFormat:@"0%zd", cents];
	}
	else {
		centString = [NSString stringWithFormat:@"%zd", cents];
	}
	
	return [NSString stringWithFormat:@"$%zd.%@", self.numberOfInsertedCents/100,centString];
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

-(void)requestProduct:(Product)product withResponse:(void (^)(BOOL didSucceed))responseBlock {
	if (self.numberOfInsertedCents >= product) {
		if (responseBlock) {
			responseBlock(YES);
		}
		return;
	}
	
	if (responseBlock) {
		responseBlock(NO);
	}
}

@end
