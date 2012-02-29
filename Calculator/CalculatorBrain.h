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
- (void)pushVarialbe:(NSString *)variable;
- (double)performOperantion:(NSString *)operation;
- (double)performOperantion:(NSString *)operation usingVariableValues:(NSDictionary *)variableValues;
- (NSString *)describeProgram;
- (NSString *)describeVariablesInProgram:(NSDictionary *)variableValues;
- (void)clearOperands;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;

@end
