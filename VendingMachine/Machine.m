//
//  Machine.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import "Machine.h"

@implementation Machine

-(NSInteger)numberOfInsertedCents {
	return 0;
}

-(BOOL)insertCoin:(NSString *)coin {
	if ([coin isEqualToString:@"PENNY"]) {
		return NO;
	}
	
	return YES;
}

@end
