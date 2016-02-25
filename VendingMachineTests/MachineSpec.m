//
//  MachineSpec.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi.h>
#import "Machine.h"

SPEC_BEGIN(MachineSpec)

describe(@"Machine", ^{
	
	__block Machine *vendingMachine;
	
	context(@"when first created", ^{
		
		vendingMachine = [[Machine alloc] init];
		
		it(@"should exist", ^{
			[[vendingMachine shouldNot] beNil];
		});
		
		it(@"should have 0 cents", ^{
			NSInteger cents = [vendingMachine numberOfInsertedCents];
			[[theValue(cents) should] equal:theValue(0)];
		});
	});
	
	context(@"when coin inserted", ^{
		it(@"should accept if valid", ^{
			BOOL wasCoinAccepted = [vendingMachine insertCoinWasAccepted:Quarter];
			[[theValue(wasCoinAccepted) should] equal:theValue(YES)];
		});
		
		it(@"should reject if invalid", ^{
			BOOL wasCoinAccepted = [vendingMachine insertCoinWasAccepted:Penny];
			[[theValue(wasCoinAccepted) should] equal:theValue(NO)];
		});
	});
});

SPEC_END
