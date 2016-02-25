//
//  ViewControllerSpec.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Machine.h"
#import "ViewController.h"
#import <Kiwi.h>

@interface ViewController ()
@property (nonatomic, strong) Machine *vendingMachine;
-(void)insertCoinAndUpdateDisplay:(Coin)coin;
@end

SPEC_BEGIN(ViewControllerSpec)

describe(@"View Controller", ^{
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	//initialize the proper View Controller from the storyboard
	__block ViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"vc"];
	
	beforeAll(^{
		[controller view];
	});
	
	context(@"after view loaded", ^{
		it(@"should exist", ^{
			[[controller shouldNot] beNil];
		});
		
		it(@"Machine should be initialized", ^{
			[[controller.vendingMachine shouldNot] beNil];
		});
	});
	
	context(@"quarter button pressed", ^{
		it(@"should insert Quarter", ^{
			[[controller shouldEventually] receive:@selector(insertCoinAndUpdateDisplay:)];
			
		});
	});
});

SPEC_END