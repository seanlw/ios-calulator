//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sean Watkins on 2/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize operationsDisplay = _operationsDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}


- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = sender.currentTitle;

    if(self.userIsInTheMiddleOfEnteringNumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }
    else{
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    
    self.operationsDisplay.text = [[self.operationsDisplay.text stringByAppendingFormat:self.display.text] stringByAppendingFormat:@" "];
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringNumber) [self enterPressed];
    double result = [self.brain performOperantion:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    self.operationsDisplay.text = [[self.operationsDisplay.text stringByAppendingFormat:sender.currentTitle] stringByAppendingFormat:@" "];
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.operationsDisplay.text = @"";
    
    self.userIsInTheMiddleOfEnteringNumber = NO;
    [self.brain clearOperands];
}

- (IBAction)decimalPressed:(UIButton *)sender {
    NSRange range = [self.display.text rangeOfString:@"."];
    if(range.location == NSNotFound){
        self.display.text = [self.display.text stringByAppendingFormat:@"."];
        self.userIsInTheMiddleOfEnteringNumber = YES;
    }
}

- (IBAction)backspacePressed {
    if(self.userIsInTheMiddleOfEnteringNumber){
        if([self.display.text length] > 1){
            self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        }
        else{
            self.display.text = @"0";
            self.userIsInTheMiddleOfEnteringNumber = NO;
        }
    }
}

- (void)viewDidUnload {
    [self setOperationsDisplay:nil];
    [super viewDidUnload];
}
@end
