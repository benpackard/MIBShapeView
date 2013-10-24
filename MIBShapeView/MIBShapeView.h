//
//  MIBShapeView.h
//  MIBShapeView
//
//  Created by Ben Packard on 10/18/13.
//  Copyright (c) 2013 Made in Bletchley. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShapeType) {
	CircleShape,
	StarShape
};

@interface MIBShapeView : UIView

@property ShapeType shapeType;
@property UIColor *foregroundColor;
@property UIColor *outlineColor;
@property CGFloat radiusScale;

@end
