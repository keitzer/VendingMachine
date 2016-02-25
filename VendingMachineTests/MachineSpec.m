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
		
		it(@"should not dispense if not enough money inserted", ^{
			__block BOOL didDispense;
			[vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
				didDispense = productDispensed;
			}];
			
			[[theValue(didDispense) should] equal:theValue(NO)];
		});
		
		context(@"with enough money inserted", ^{
			
			__block BOOL didDispense;
			
			beforeEach(^{
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				
				[vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
					didDispense = productDispensed;
				}];
			});
			
			it(@"should allow dispensed product", ^{
				
				[[theValue(didDispense) should] equal:theValue(YES)];
			});
			
			it(@"should display THANK YOU if display checked", ^{
				NSString *displayValue = [vendingMachine getScreenDisplayValue];
				[[displayValue should] equal:@"THANK YOU"];
			});
		});
		
	});
});

SPEC_END
