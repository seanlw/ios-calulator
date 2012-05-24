//
//  GraphView.m
//  Calculator
//
//  Created by Sean Watkins on 5/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define DEFAULT_SCALE 1.0
- (CGFloat)scale
{
    if(!_scale){
        return DEFAULT_SCALE;
    }
    else{
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if(scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (CGPoint)origin
{
    if(_origin.x == 0 && _origin.y == 0){
        CGPoint midPoint;
        midPoint.x = self.bounds.origin.x + self.bounds.size.width / 2;
        midPoint.y = self.bounds.origin.y + self.bounds.size.height / 2;
        return midPoint;
    }
    else{
        return _origin;
    }
}

- (void)setOrigin:(CGPoint)origin
{
    if(origin.x != _origin.x && origin.y != _origin.y){
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)){
        self.origin = [gesture translationInView:self];
        [gesture setTranslation:self.origin inView:self];
    }
    else if(gesture.state == UIGestureRecognizerStateBegan) {
        [gesture setTranslation:self.origin inView:self];
    }
}

- (void)tripleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.origin = [gesture locationInView:self];
    }
}


- (void)drawRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [[UIColor purpleColor] setStroke];
    
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    
    
    
}


@end
