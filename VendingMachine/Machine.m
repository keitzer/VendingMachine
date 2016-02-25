//
//  Machine.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import "Machine.h"

@interface Machine ()
@property (nonatomic, assign) NSInteger numberOfInsertedCents;
@end

@implementation Machine

-(NSInteger)getNumberOfInsertedCents {
	return self.numberOfInsertedCents;
}

-(BOOL)insertCoinWasAccepted:(Coin)coin {
	if (coin == Penny) {
		return NO;
	}
	
	self.numberOfInsertedCents += coin;
	
	return YES;
}

@end
