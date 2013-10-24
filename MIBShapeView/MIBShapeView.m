//
//  MIBShapeView.m
//  MIBShapeView
//
//  Created by Ben Packard on 10/18/13.
//  Copyright (c) 2013 Made in Bletchley. All rights reserved.
//

#import "MIBShapeView.h"

@implementation MIBShapeView

@synthesize foregroundColor = _foregroundColor;
@synthesize outlineColor = _outlineColor;
@synthesize shapeType = _shapeType;
@synthesize radiusScale = _radiusScale;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		//some obnoxious default colors
		self.shapeType = CircleShape;
		self.backgroundColor = [UIColor greenColor];
		self.foregroundColor = [UIColor redColor];
		self.outlineColor = nil;
		self.radiusScale = 1.0f;
    }
    
	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	if (self.shapeType == CircleShape)
	{
		//draw a circle
		CGFloat margin = (1.0f - self.radiusScale) * self.frame.size.width/2;
		CGContextAddEllipseInRect(ctx, CGRectMake(margin, margin, self.frame.size.width - (2 * margin), self.frame.size.height - (2 * margin)));
		CGContextSetFillColor(ctx, CGColorGetComponents([self.foregroundColor CGColor]));
		CGContextSetStrokeColor(ctx, CGColorGetComponents(self.outlineColor ? [self.outlineColor CGColor] : [self.foregroundColor CGColor]));
		CGContextDrawPath(ctx, kCGPathFillStroke);
	}
	else
	{
		[self drawStarInContext:ctx
			 withNumberOfPoints:5
						 center:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
					innerRadius:self.bounds.size.width * 0.2f * self.radiusScale
					outerRadius:self.bounds.size.width * 0.5f * self.radiusScale
					  fillColor:self.foregroundColor
					strokeColor:self.outlineColor ? self.outlineColor : self.foregroundColor
					strokeWidth:1.0f];
	}
}

- (void)drawStarInContext:(CGContextRef)context
	   withNumberOfPoints:(NSInteger)points
				   center:(CGPoint)center
			  innerRadius:(CGFloat)innerRadius
			  outerRadius:(CGFloat)outerRadius
				fillColor:(UIColor *)fill
			  strokeColor:(UIColor *)stroke
			  strokeWidth:(CGFloat)strokeWidth
{
    CGFloat arcPerPoint = 2.0f * M_PI / points;
    CGFloat theta = M_PI / 2.0f;
	
    // Move to starting point (tip at 90 degrees on outside of star)
    CGPoint pt = CGPointMake(center.x - (outerRadius * cosf(theta)), center.y - (outerRadius * sinf(theta)));
    CGContextMoveToPoint(context, pt.x, pt.y);
	
    for (int i = 0; i < points; i = i + 1)
	{
        // Calculate next inner point (moving clockwise), accounting for crossing of 0 degrees
        theta = theta - (arcPerPoint / 2.0f);
        if (theta < 0.0f)
		{
            theta = theta + (2 * M_PI);
        }
        pt = CGPointMake(center.x - (innerRadius * cosf(theta)), center.y - (innerRadius * sinf(theta)));
        CGContextAddLineToPoint(context, pt.x, pt.y);
		
        // Calculate next outer point (moving clockwise), accounting for crossing of 0 degrees
        theta = theta - (arcPerPoint / 2.0f);
        if (theta < 0.0f)
		{
            theta = theta + (2 * M_PI);
        }
        pt = CGPointMake(center.x - (outerRadius * cosf(theta)), center.y - (outerRadius * sinf(theta)));
        CGContextAddLineToPoint(context, pt.x, pt.y);
    }
	
    CGContextClosePath(context);
    CGContextSetLineWidth(context, strokeWidth);
    [fill setFill];
    [stroke setStroke];
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)setForegroundColor:(UIColor *)foregroundColor
{
	//force a redraw when the color is changed
	_foregroundColor = foregroundColor;
	[self setNeedsDisplay];
}

- (UIColor *)foregroundColor
{
	return _foregroundColor;
}

- (void)setOutlineColor:(UIColor *)outlineColor
{
	//force a redraw when the color is changed
	_outlineColor = outlineColor;
	[self setNeedsDisplay];
}

- (UIColor *)outlineColor
{
	return _outlineColor;
}

- (void)setShapeType:(ShapeType)shapeType
{
	//force a redraw when the color is changed
	_shapeType = shapeType;
	[self setNeedsDisplay];
}

- (ShapeType)shapeType
{
	return _shapeType;
}

- (CGFloat)radiusScale
{
	return _radiusScale;
}

- (void)setRadiusScale:(CGFloat)radiusScale
{
	_radiusScale = radiusScale;
	[self setNeedsDisplay];
}

@end
