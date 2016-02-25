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

//for tracking if we should display THANK YOU when display is checked
@property (nonatomic, assign) BOOL shouldDisplayThankYou;
@end


@implementation Machine

-(NSInteger)getNumberOfInsertedCents {
	return self.numberOfInsertedCents;
}

-(NSInteger)getNumberOfCoinReturnCents {
	return self.numberOfCoinReturnCents;
}

-(NSString *)getScreenDisplayValue {
	
	//if we recently made a purchase, display "THANK YOU"
	if (self.shouldDisplayThankYou) {
		self.shouldDisplayThankYou = NO;
		return @"THANK YOU";
	}
	
	//if there are no inserted coins, say "INSERT COIN"
	if (self.numberOfInsertedCents == 0) {
		return @"INSERT COIN";
	}
	
	//create either 0# or ## for the cents label
	NSInteger cents = self.numberOfInsertedCents % 100;
	NSString *centString;
	if (cents < 10) {
		centString = [NSString stringWithFormat:@"0%zd", cents];
	}
	else {
		centString = [NSString stringWithFormat:@"%zd", cents];
	}
	
	//then create the $#.## label for the display value (if displaying the valuation of inserted money)
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
	
	//add the coin valuation to the number of inserted coins
	self.numberOfInsertedCents += coin;
	
	return YES;
}

-(void)requestProduct:(Product)product withResponse:(void (^)(BOOL productDispensed))responseBlock {
	
	//first check if we have enough coins to purchase the product requested
	if (self.numberOfInsertedCents >= product) {
		
		//if so, we should display THANK YOU, and set our coins to 0
		self.shouldDisplayThankYou = YES;
		self.numberOfInsertedCents = 0;
		
		//then run the Response Block with YES for "product dispensed"
		if (responseBlock) {
			responseBlock(YES);
		}
		//return so the other code doesn't get called
		return;
	}
	
	//If we don't have enough, send back "No"
	if (responseBlock) {
		responseBlock(NO);
	}
}

@end
