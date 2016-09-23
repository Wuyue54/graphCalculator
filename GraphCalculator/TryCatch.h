//
//  TryCatch.h
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/15/16.
//  Copyright © 2016 CS2048 Instructor. All rights reserved.
//

#ifndef TryCatch_h
#define TryCatch_h

#import <Foundation/Foundation.h>

@interface TryCatch : NSObject

+ (BOOL)tryBlock:(void(^)())tryBlock
           error:(NSError **)error;

@end

#endif /* TryCatch_h */
