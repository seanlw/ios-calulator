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
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;
@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize description = _description;
@synthesize brain = _brain;
@synthesize graphVariables = _graphVariables;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)setDescription:(NSString *)description{
    _description = description;
    self.title = self.description;
    // display the description in the detail toolbar
    if (self.splitViewController) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        UIBarButtonItem *baritem = [toolbarItems objectAtIndex:(toolbarItems.count - 2)];
        baritem.title = self.description;
        [toolbarItems replaceObjectAtIndex:(toolbarItems.count - 2) withObject:baritem];
        self.toolbar.items = toolbarItems;
    }
    [self.graphView setNeedsDisplay];
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
