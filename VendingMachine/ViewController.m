//
//  ViewController.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import "ViewController.h"
#import "Machine.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UIButton *quarterButton;
@property (nonatomic, weak) IBOutlet UIButton *dimeButton;
@property (nonatomic, weak) IBOutlet UIButton *nickelButton;
@property (nonatomic, weak) IBOutlet UIButton *pennyButton;

@property (nonatomic, weak) IBOutlet UIButton *colaButton;
@property (nonatomic, weak) IBOutlet UIButton *chipsButton;
@property (nonatomic, weak) IBOutlet UIButton *candyButton;

@property (nonatomic, weak) IBOutlet UILabel *displayLabel;
@property (nonatomic, weak) IBOutlet UILabel *coinReturnLabel;
@property (nonatomic, strong) Machine *vendingMachine;

@property (nonatomic, strong) NSTimer *displayUpdateTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.vendingMachine = [[Machine alloc] init];
}

-(IBAction)quarterButtonPressed {
	[self insertCoinAndUpdateDisplay:Quarter];
}

-(IBAction)dimeButtonPressed {
	[self insertCoinAndUpdateDisplay:Dime];
}

-(IBAction)nickelButtonPressed {
	[self insertCoinAndUpdateDisplay:Nickel];
}

-(IBAction)pennyButtonPressed {
	[self insertCoinAndUpdateDisplay:Penny];
}

-(void)insertCoinAndUpdateDisplay:(Coin)coin {
	[self.vendingMachine insertCoinWasAccepted:coin];
	
	[self updateDisplayLabel];
}

-(void)updateDisplayLabel {
	self.displayLabel.text = [self.vendingMachine getScreenDisplayValue];
	
	NSInteger cents = [self.vendingMachine getNumberOfCoinReturnCents] % 100;
	NSString *centString;
	if (cents < 10) {
		centString = [NSString stringWithFormat:@"0%zd", cents];
	}
	else {
		centString = [NSString stringWithFormat:@"%zd", cents];
	}
	
	self.coinReturnLabel.text = [NSString stringWithFormat:@"$%zd.%@", [self.vendingMachine getNumberOfCoinReturnCents]/100,centString];
}

-(IBAction)colaButtonPressed {
	[self.vendingMachine requestProduct:Cola withResponse:^(BOOL productDispensed) {
		[self cancelTimerAndUpdateDisplayTwiceAfterPurchaseRequest];
	}];
}

-(IBAction)chipsButtonPressed {
	[self.vendingMachine requestProduct:Chips withResponse:^(BOOL productDispensed) {
		[self cancelTimerAndUpdateDisplayTwiceAfterPurchaseRequest];
	}];
}

-(IBAction)candyButtonPressed {
	[self.vendingMachine requestProduct:Candy withResponse:^(BOOL productDispensed) {
		[self cancelTimerAndUpdateDisplayTwiceAfterPurchaseRequest];
	}];
}

-(void)cancelTimerAndUpdateDisplayTwiceAfterPurchaseRequest {
	[self.displayUpdateTimer invalidate];
	self.displayUpdateTimer = nil;
	
	[self updateDisplayLabel];
	
	self.displayUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateDisplayLabel) userInfo:nil repeats:NO];
}

@end
