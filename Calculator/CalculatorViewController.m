//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sean Watkins on 2/21/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSMutableDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize operationsDisplay = _operationsDisplay;
@synthesize variableDisplay = _variableDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber = _userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain{
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSMutableDictionary *)testVariableValues{
    if(!_testVariableValues) _testVariableValues = [[NSMutableDictionary alloc] init];
    return _testVariableValues;
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
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringNumber) [self enterPressed];
    double result = [self.brain performOperantion:sender.currentTitle usingVariableValues:[self.testVariableValues copy]];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    self.operationsDisplay.text = [self.brain describeProgram];
    self.variableDisplay.text = [self.brain describeVariablesInProgram:[self.testVariableValues copy]];
}

- (IBAction)clearPressed {
    self.display.text = @"0";
    self.operationsDisplay.text = @"";
    self.variableDisplay.text = @"";
    
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

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVarialbe:sender.currentTitle];
    self.userIsInTheMiddleOfEnteringNumber = NO;
}

- (IBAction)testPressed:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"Test 1"]){
        [self.testVariableValues setObject:[NSNumber numberWithDouble:5] forKey:@"x"];
        [self.testVariableValues setObject:[NSNumber numberWithDouble:4.8] forKey:@"y"];
        [self.testVariableValues setObject:[NSNumber numberWithDouble:0] forKey:@"foo"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Graph"]) {
        [segue.destinationViewController setDescription:[self.brain describeProgram]];
        [segue.destinationViewController setBrain:self.brain];
        [segue.destinationViewController setGraphVariables:self.testVariableValues];
    }
}

- (void)viewDidUnload {
    [self setOperationsDisplay:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
