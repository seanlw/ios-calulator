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

- (void)setOperandStack:(NSMutableArray *)programStack{
    _programStack = programStack;
}

- (NSMutableArray *)programStack{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)pushOperand:(double)operand{
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperantion:(NSString *)operation{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

- (id)program{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program{
    return @"Implement in Assignment";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        }
        else if([operation isEqualToString:@"-"]){
            result = [self popOperandOffStack:stack] - [self popOperandOffStack:stack];
        }
        else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result = [self popOperandOffStack:stack] / divisor;
        }
        else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
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
