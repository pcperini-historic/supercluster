//
//  UIView+NibExtensions.m
//  supercluster
//
//  Created by Patrick Perini on 2/28/15.
//  Copyright (c) 2015 perini-hestin. All rights reserved.
//

#import "UIView+NibExtensions.h"

@implementation UIView (NibExtensions)

- (id)initWithNib:(id)owner
{
    NSString *className = NSStringFromClass([self class]);
    if ([className rangeOfString: @"."].location != NSNotFound) {
        className = [[className componentsSeparatedByString: @"."] lastObject];
    }
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed: className
                                                        owner: nil
                                                      options: nil];
    
    for (id nibObject in nibObjects)
    {
        if ([nibObject isKindOfClass: [self class]])
        {
            self = nibObject;
            break;
        }
    }
    
    if (!self)
        return nil;
    
    return self;
}

@end
