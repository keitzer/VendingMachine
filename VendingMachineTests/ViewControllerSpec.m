//
//  ViewControllerSpec.m
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import <Kiwi.h>

SPEC_BEGIN(ViewControllerSpec)

describe(@"View Controller", ^{
	

	//initialize the proper View Controller from the storyboard
	__block ViewController *vc;
	
	context(@"after view loaded", ^{
		it(@"should exist", ^{
			[[vc shouldNot] beNil];
		});
	});
});

SPEC_END