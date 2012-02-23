//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Sean Watkins on 2/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand{
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperantion:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (id)program{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program{
    return @"Implement this in A2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if([operation isEqualToString:@"-"]){
            double subtrackend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrackend;
        }
        else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }
        else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"√"]){
            result = sqrt([self popOperandOffStack:stack]);
        }
        else if([operation isEqualToString:@"π"]){
            result = M_PI;
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program{
    NSMutableArray *stack;
    
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

- (void)clearOperands{
    [self.programStack removeAllObjects];
}

@end
