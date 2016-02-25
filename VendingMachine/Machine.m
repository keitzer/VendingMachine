//
//  Machine.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import "Machine.h"

@interface Machine ()
@property (nonatomic, assign) NSInteger numberOfInsertedCoins;
@end

@implementation Machine

-(NSInteger)getNumberOfInsertedCents {
	return self.numberOfInsertedCoins;
}

-(BOOL)insertCoinWasAccepted:(Coin)coin {
	if (coin == Penny) {
		return NO;
	}
	
	return YES;
}

@end
