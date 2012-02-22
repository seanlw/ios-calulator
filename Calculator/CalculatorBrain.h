//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Sean Watkins on 2/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperantion:(NSString *)operation;
- (void)clearOperands;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
