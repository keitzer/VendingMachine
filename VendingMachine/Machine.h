//
//  Machine.h
//  VendingMachine
//
//  Created by Alex Ogorek on 2/25/16.
//  Copyright © 2016 Kata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Machine : NSObject

-(NSInteger)numberOfInsertedCents;
-(BOOL)insertCoin:(NSString*)coin;
@end
