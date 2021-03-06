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
		
		it(@"should display INSERT COINS", ^{
			[[[vendingMachine getScreenDisplayValue] should] equal:@"INSERT COINS"];
		});
	});
	
	context(@"when Product requested", ^{
		beforeEach(^{
			vendingMachine = [[Machine alloc] init];
		});
		
		
		context(@"with enough money inserted", ^{
			
			__block BOOL didDispense;
			__block NSString *displayValueRightAfterProductRequest;
			__block NSString *displayValueOnSecondDisplayCheck;
			__block NSInteger numCoinsInReturnBeforePurchase;
			
			beforeEach(^{
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				
				numCoinsInReturnBeforePurchase = [vendingMachine getNumberOfCoinReturnCents];
				
				[vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
					didDispense = productDispensed;
				}];
				
				displayValueRightAfterProductRequest = [vendingMachine getScreenDisplayValue];
				displayValueOnSecondDisplayCheck = [vendingMachine getScreenDisplayValue];
			});
			
			it(@"should allow dispensed product", ^{
				[[theValue(didDispense) should] equal:theValue(YES)];
			});
			
			
			it(@"should display THANK YOU if display checked", ^{
				[[displayValueRightAfterProductRequest should] equal:@"THANK YOU"];
			});
			
			it(@"should set inserted coins to 0", ^{
				NSInteger numCoins = [vendingMachine getNumberOfInsertedCents];
				[[theValue(numCoins) should] equal:theValue(0)];
			});
			
			it(@"should display INSERT COINS if display checked again", ^{
				[[displayValueOnSecondDisplayCheck should] equal:@"INSERT COINS"];
			});
			
			it(@"should put remaining money in coin return", ^{
				NSInteger numCoinsInReturnAfterPurchase = [vendingMachine getNumberOfCoinReturnCents];
				[[theValue(numCoinsInReturnAfterPurchase - numCoinsInReturnBeforePurchase) should] equal:theValue(25)];
			});
		});
		
		context(@"with no enough money inserted", ^{
			
			__block BOOL didDispense;
			__block NSString *displayValueRightAfterProductRequest;
			__block NSString *displayValueOnSecondDisplayCheck;
			
			beforeEach(^{
				[vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
					didDispense = productDispensed;
				}];
				
				displayValueRightAfterProductRequest = [vendingMachine getScreenDisplayValue];
				displayValueOnSecondDisplayCheck = [vendingMachine getScreenDisplayValue];
			});
			
			it(@"should NOT allow dispensed product", ^{
				[[theValue(didDispense) should] equal:theValue(NO)];
			});
			
			it(@"should display PRICE: $1.00 if display checked", ^{
				[[displayValueRightAfterProductRequest should] equal:@"PRICE: $1.00"];
			});
			
			it(@"should display INSERT COINS if display checked again", ^{
				[[displayValueOnSecondDisplayCheck should] equal:@"INSERT COINS"];
			});
		});
		
		context(@"with SOME but not enough money inserted", ^{
			__block BOOL didDispense;
			__block NSString *displayValueRightAfterProductRequest;
			__block NSString *displayValueOnSecondDisplayCheck;
			
			beforeEach(^{
				[vendingMachine insertCoinWasAccepted:Quarter];
				[vendingMachine insertCoinWasAccepted:Quarter];
				
				[vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
					didDispense = productDispensed;
				}];
				
				displayValueRightAfterProductRequest = [vendingMachine getScreenDisplayValue];
				displayValueOnSecondDisplayCheck = [vendingMachine getScreenDisplayValue];
			});
			
			it(@"should NOT allow dispensed product", ^{
				[[theValue(didDispense) should] equal:theValue(NO)];
			});
			
			it(@"should display PRICE: $1.00 if display checked", ^{
				[[displayValueRightAfterProductRequest should] equal:@"PRICE: $1.00"];
			});
			
			it(@"should display $0.50 if display checked again", ^{
				[[displayValueOnSecondDisplayCheck should] equal:@"$0.50"];
			});
		});
	});
});

SPEC_END
