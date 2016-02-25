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
		
		it(@"should exist", ^{
			[[vendingMachine shouldNot] beNil];
		});
	});
});

SPEC_END
