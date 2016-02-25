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

@interface ViewController (Spec)
@property (nonatomic, weak) IBOutlet UIButton *quarterButton;
@property (nonatomic, weak) IBOutlet UIButton *dimeButton;
@property (nonatomic, weak) IBOutlet UIButton *nickelButton;
@property (nonatomic, weak) IBOutlet UIButton *pennyButton;
@property (nonatomic, weak) IBOutlet UILabel *displayLabel;
@property (nonatomic, weak) IBOutlet UILabel *coinReturnLabel;

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
		it(@"should insert proper Quarter valuation", ^{
			NSInteger centsBeforePress = [controller.vendingMachine getNumberOfInsertedCents];
			[controller.quarterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSInteger centsAfterPress = [controller.vendingMachine getNumberOfInsertedCents];
			
			[[theValue(centsAfterPress - centsBeforePress) should] equal:theValue(Quarter)];
		});
		
		it(@"should update the display label", ^{
			NSString *beforePress = controller.displayLabel.text;
			[controller.quarterButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSString *afterPress = controller.displayLabel.text;
			
			[[theValue([beforePress isEqualToString:afterPress]) should] equal:theValue(NO)];
		});
	});
	
	context(@"dime button pressed", ^{
		it(@"should insert Dime", ^{
			NSInteger centsBeforePress = [controller.vendingMachine getNumberOfInsertedCents];
			[controller.dimeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSInteger centsAfterPress = [controller.vendingMachine getNumberOfInsertedCents];
			
			[[theValue(centsAfterPress - centsBeforePress) should] equal:theValue(Dime)];
		});
	});
	
});

SPEC_END


