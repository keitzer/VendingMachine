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
			NSInteger cents = [vendingMachine getNumberOfInsertedCents];
			[[theValue(cents) should] equal:theValue(0)];
		});
	});
	
	context(@"when coin inserted", ^{
		
		//ensure the Vending Machine is fresh before each subsequent test
		beforeEach(^{
			vendingMachine = [[Machine alloc] init];
		});
		
		it(@"should accept if valid", ^{
			BOOL wasCoinAccepted = [vendingMachine insertCoinWasAccepted:Quarter];
			[[theValue(wasCoinAccepted) should] equal:theValue(YES)];
		});
		
		it(@"should reject if invalid", ^{
			BOOL wasCoinAccepted = [vendingMachine insertCoinWasAccepted:Penny];
			[[theValue(wasCoinAccepted) should] equal:theValue(NO)];
		});
		
		it(@"should increase the total number of cents", ^{
			[vendingMachine insertCoinWasAccepted:Quarter];
			[[theValue([vendingMachine getNumberOfInsertedCents]) should] equal:theValue(25)];
		});
		
		it(@"should place rejected coins in coin return", ^{
			[vendingMachine insertCoinWasAccepted:Penny];
			[[theValue([vendingMachine getNumberOfCoinReturnCents]) should] equal:theValue(1)];
		});
		
		it(@"should display the total amount inserted", ^{
			[vendingMachine insertCoinWasAccepted:Quarter];
			[[[vendingMachine getScreenDisplayValue] should] equal:@"$0.25"];
		});
	});
	
	context(@"when no coins inserted", ^{
		beforeEach(^{
			vendingMachine = [[Machine alloc] init];
		});
		
		it(@"should display INSERT COIN", ^{
			[[[vendingMachine getScreenDisplayValue] should] equal:@"INSERT COIN"];
		});
	});
	
	context(@"when Product requested", ^{
		beforeEach(^{
			vendingMachine = [[Machine alloc] init];
		});
		
		it(@"should return PRICE: (price) if not enough money inserted", ^{
			NSString *responseValue = [vendingMachine requestProductWithResponse:Cola];
			[[responseValue should] equal:@"PRICE: $1.00"];
		});
		
		it(@"should return THANK YOU if enough money is inserted", ^{
			[vendingMachine insertCoinWasAccepted:Quarter];
			[vendingMachine insertCoinWasAccepted:Quarter];
			[vendingMachine insertCoinWasAccepted:Quarter];
			[vendingMachine insertCoinWasAccepted:Quarter];
			
			NSString *responseValue = [vendingMachine requestProductWithResponse:Cola];
			[[responseValue should] equal:@"THANK YOU"];
		});
	});
});

SPEC_END
