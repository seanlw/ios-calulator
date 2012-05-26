//
//  GraphViewController.h
//  Calculator
//
//  Created by Sean Watkins on 5/24/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController

@property (nonatomic, weak) NSString *description;
@property (nonatomic, weak) CalculatorBrain *brain;
@property (nonatomic, weak) NSMutableDictionary *graphVariables;

@end
