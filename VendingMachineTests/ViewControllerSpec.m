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

@property (nonatomic, weak) IBOutlet UIButton *colaButton;
@property (nonatomic, weak) IBOutlet UIButton *chipsButton;
@property (nonatomic, weak) IBOutlet UIButton *candyButton;

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
		
		it(@"should update the display label", ^{
			NSString *beforePress = controller.displayLabel.text;
			[controller.dimeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSString *afterPress = controller.displayLabel.text;
			
			[[theValue([beforePress isEqualToString:afterPress]) should] equal:theValue(NO)];
		});
	});
	
	context(@"nickel button pressed", ^{
		it(@"should insert Nickel", ^{
			NSInteger centsBeforePress = [controller.vendingMachine getNumberOfInsertedCents];
			[controller.nickelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSInteger centsAfterPress = [controller.vendingMachine getNumberOfInsertedCents];
			
			[[theValue(centsAfterPress - centsBeforePress) should] equal:theValue(Nickel)];
		});
		
		it(@"should update the display label", ^{
			NSString *beforePress = controller.displayLabel.text;
			[controller.nickelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSString *afterPress = controller.displayLabel.text;
			
			[[theValue([beforePress isEqualToString:afterPress]) should] equal:theValue(NO)];
		});
	});
	
	context(@"penny button pressed", ^{
		it(@"should add a Penny to the Coin Return", ^{
			NSInteger centsBeforePress = [controller.vendingMachine getNumberOfCoinReturnCents];
			[controller.pennyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSInteger centsAfterPress = [controller.vendingMachine getNumberOfCoinReturnCents];
			
			[[theValue(centsAfterPress - centsBeforePress) should] equal:theValue(Penny)];
		});
		
		it(@"should update the Coin Return label", ^{
			NSString *beforePress = controller.coinReturnLabel.text;
			[controller.pennyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			NSString *afterPress = controller.coinReturnLabel.text;
			
			[[theValue([beforePress isEqualToString:afterPress]) should] equal:theValue(NO)];
		});
	});
	
	context(@"purchase cola button pressed", ^{
		
		it(@"should request the Cola product", ^{
			[[controller.vendingMachine shouldEventually] receive:@selector(requestProduct:withResponse:) withArguments:theValue(Cola), any()];
			
			[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		});
		
		context(@"with enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchase;
			__block NSString *displayTextAfterPurchase;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				
				displayTextBeforePurchase = controller.displayLabel.text;
			});
			
			it(@"should dispense cola (by saying THANK YOU)", ^{
				[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchase = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchase shouldNot] equal:displayTextBeforePurchase];
			});
			
			it(@"should update the coin return label to the correct amount", ^{
				[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				[[controller.coinReturnLabel.text should] equal:@"$0.25"];
			});
			
			it(@"should display something else (INSERT COINS) after 2 seconds", ^{
				
				[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldNotAfterWaitOf(2.0)] equal:displayTextAfterPurchase];
			});
		});
		
		context(@"with no enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchaseAttempt;
			__block NSString *displayTextAfterPurchaseAttempt;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				displayTextBeforePurchaseAttempt = controller.displayLabel.text;
			});
			
			it(@"should display PRICE: $1.00", ^{
				[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchaseAttempt = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchaseAttempt shouldNot] equal:displayTextBeforePurchaseAttempt];
			});
			
			it(@"should display same text after 2 seconds", ^{
				[controller.colaButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldAfterWaitOf(2.0)] equal:displayTextBeforePurchaseAttempt];
			});
		});
	});
	
	context(@"purchase Chips button pressed", ^{
		
		it(@"should request the Chips product", ^{
			[[controller.vendingMachine shouldEventually] receive:@selector(requestProduct:withResponse:) withArguments:theValue(Chips), any()];
			
			[controller.chipsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		});
		
		context(@"with enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchase;
			__block NSString *displayTextAfterPurchase;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				
				displayTextBeforePurchase = controller.displayLabel.text;
			});
			
			it(@"should dispense chips (by saying THANK YOU)", ^{
				[controller.chipsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchase = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchase shouldNot] equal:displayTextBeforePurchase];
			});
			
			it(@"should display something else (INSERT COINS) after 2 seconds", ^{
				
				[controller.chipsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldNotAfterWaitOf(2.0)] equal:displayTextAfterPurchase];
			});
		});
		
		context(@"with no enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchaseAttempt;
			__block NSString *displayTextAfterPurchaseAttempt;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				displayTextBeforePurchaseAttempt = controller.displayLabel.text;
			});
			
			it(@"should display PRICE: $1.00", ^{
				[controller.chipsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchaseAttempt = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchaseAttempt shouldNot] equal:displayTextBeforePurchaseAttempt];
			});
			
			it(@"should display same text after 2 seconds", ^{
				[controller.chipsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldAfterWaitOf(2.0)] equal:displayTextBeforePurchaseAttempt];
			});
		});
	});
	
	context(@"purchase Candy button pressed", ^{
		
		it(@"should request the Candy product", ^{
			[[controller.vendingMachine shouldEventually] receive:@selector(requestProduct:withResponse:) withArguments:theValue(Candy), any()];
			
			[controller.candyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		});
		
		context(@"with enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchase;
			__block NSString *displayTextAfterPurchase;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				[controller.vendingMachine insertCoinWasAccepted:Quarter];
				
				displayTextBeforePurchase = controller.displayLabel.text;
			});
			
			it(@"should dispense candy (by saying THANK YOU)", ^{
				[controller.candyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchase = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchase shouldNot] equal:displayTextBeforePurchase];
			});
			
			it(@"should display something else (INSERT COINS) after 2 seconds", ^{
				
				[controller.candyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldNotAfterWaitOf(2.0)] equal:displayTextAfterPurchase];
			});
		});
		
		context(@"with no enough money inserted", ^{
			
			__block NSString *displayTextBeforePurchaseAttempt;
			__block NSString *displayTextAfterPurchaseAttempt;
			
			beforeAll(^{
				controller.vendingMachine = [[Machine alloc] init];
				
				displayTextBeforePurchaseAttempt = controller.displayLabel.text;
			});
			
			it(@"should display PRICE: $1.00", ^{
				[controller.candyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				displayTextAfterPurchaseAttempt = controller.displayLabel.text;
				
				//just make sure the text is NOT the same from before to after
				[[displayTextAfterPurchaseAttempt shouldNot] equal:displayTextBeforePurchaseAttempt];
			});
			
			it(@"should display same text after 2 seconds", ^{
				[controller.candyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
				
				//just make sure the text is NOT the same from after to 2-seconds after
				[[expectFutureValue(controller.displayLabel.text) shouldAfterWaitOf(2.0)] equal:displayTextBeforePurchaseAttempt];
			});
		});
	});
	
});

SPEC_END


