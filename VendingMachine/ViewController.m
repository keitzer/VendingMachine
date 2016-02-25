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
@property (nonatomic, weak) IBOutlet UILabel *displayLabel;
@property (nonatomic, weak) IBOutlet UILabel *coinReturnLabel;
@property (nonatomic, strong) Machine *vendingMachine;
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
	self.displayLabel.text = [self.vendingMachine getScreenDisplayValue];
}

@end
