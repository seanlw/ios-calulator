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
@property (nonatomic, strong) NSMutableArray *descriptionStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize descriptionStack = _descriptionStack;

- (NSMutableArray *)programStack{
    if(_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (NSMutableArray *)descriptionStack{
    if(_descriptionStack == nil) _descriptionStack = [[NSMutableArray alloc] init];
    return _descriptionStack;
}

- (void)pushOperand:(double)operand{
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperantion:(NSString *)operation{
    
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

- (void)clearOperands{
    [self.programStack removeAllObjects];
    [self.descriptionStack removeAllObjects];
}

- (id)program{
    return [self.programStack copy];
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

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues{
    NSMutableArray *stack;
    
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
        /* steping through the stack to replace variableValues */
        for(NSUInteger i = 0;i < [stack count]; i++){
            if([[stack objectAtIndex:i] isKindOfClass:[NSString class]] && ![self isOperation:[stack objectAtIndex:i]]){
                NSNumber *variableValue = [variableValues objectForKey:[stack objectAtIndex:i]];
                if(!variableValue) variableValue = 0;
                [stack replaceObjectAtIndex:i withObject:variableValue];
            }
        }
    }
    
    return [self popOperandOffStack:stack];
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack{
    
}

+ (NSString *)descriptionOfProgram:(id)program{
    NSMutableArray * stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    return [self descriptionOfTopOfStack:stack];
}

+ (BOOL)isOperation:(NSString *)operation{
    return [[NSSet setWithObjects:@"+", @"-", @"/", @"*", @"sin", @"cos", @"√", @"π", nil] containsObject:operation];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet *result;
    
    for(id operand in program){
        if([operand isKindOfClass:[NSString class]] && ![self isOperation:operand]){
            if(!result) result = [[NSMutableSet alloc] init];
            [result addObject:operand];
        }
    }
    
    return [result copy];
}

@end
