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
#import "SplitViewBarButtonItemPresenter.h"

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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]){
        detailVC = nil;
    }
    return detailVC;
}

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

- (GraphViewController *)splitViewGraphViewController
{
    id hvc = [self.splitViewController.viewControllers lastObject];
    if(![hvc isKindOfClass:[GraphViewController class]]) {
        hvc = nil;
    }
    return hvc;
}

- (IBAction)graph {
    if ([self splitViewGraphViewController]) {
        [self splitViewGraphViewController].description  = [self.brain describeProgram];
        [self splitViewGraphViewController].brain = self.brain;
        [self splitViewGraphViewController].graphVariables = self.testVariableValues;
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

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   return (self.splitViewController) ? YES : (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setOperationsDisplay:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
