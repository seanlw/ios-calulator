//
//  GraphView.h
//  Calculator
//
//  Created by Sean Watkins on 5/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphView;

@protocol graphViewDatasource
- (CGFloat)getYAxesValueForGraphView:(GraphView *)sender xAxesPoint:(CGFloat)xAtPoint originAtPoint:(CGPoint)axisOrigin scale:(CGFloat)pointsPerUnit;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint origin;

@property (nonatomic, weak) IBOutlet id <graphViewDatasource> dataSource;

- (void)loadUserGraphDefaults;
- (void)pinch:(UIPinchGestureRecognizer *)gesture;
- (void)pan:(UIPanGestureRecognizer *)gesture;
- (void)tripleTap:(UITapGestureRecognizer *)gesture;

@end
