//
//  GraphViewController.m
//  Calculator
//
//  Created by Sean Watkins on 5/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"

@interface GraphViewController() <graphViewDatasource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize description = _description;
@synthesize brain = _brain;
@synthesize graphVariables = _graphVariables;

- (void)setDescription:(NSString *)description{
    _description = description;
    self.title = self.description;
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)]];
    // add triple tap
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(tripleTap:)];
    [tapRecognizer setNumberOfTapsRequired:3];
    [self.graphView addGestureRecognizer:tapRecognizer];
    self.graphView.dataSource = self;
}

- (CGFloat)getYAxesValueForGraphView:(GraphView *)sender xAxesPoint:(CGFloat)xAtPoint originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)pointsPerUnit
{
    
    [self.graphVariables setObject:[NSNumber numberWithDouble:((xAtPoint - axisOrigin.x) / pointsPerUnit)] forKey:@"x"];
    
    return axisOrigin.y - ([[self.brain class] runProgram:self.brain.program usingVariableValues:self.graphVariables] * pointsPerUnit);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
