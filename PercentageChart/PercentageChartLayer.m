//
//  PercentageChartLayer.m
//  PercentageChart
//
//  Created by Xavi Gil on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PercentageChartLayer.h"

@implementation PercentageChartLayer

@dynamic percentage;

@synthesize mainColor;
@synthesize secondaryColor;
@synthesize lineColor;

-(CABasicAnimation *)makeAnimationForKey:(NSString *)key 
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
	anim.fromValue = [[self presentationLayer] valueForKey:key];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	anim.duration = 0.5;
    
	return anim;
}

-(id<CAAction>)actionForKey:(NSString *)event 
{
    if ( [event isEqualToString:@"percentage"] ) 
        return [self makeAnimationForKey:event];
    
    return [super actionForKey:event];
}

- (id)initWithLayer:(id)aLayer 
{
    if (self = [super initWithLayer:aLayer]) 
    {
        if ([aLayer isKindOfClass:[PercentageChartLayer class]]) 
        {
            PercentageChartLayer *layer = (PercentageChartLayer *)aLayer;
            self.percentage = layer.percentage;
            self.mainColor = layer.mainColor;
            self.secondaryColor = layer.secondaryColor;            
            self.lineColor = layer.lineColor;
        }
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key 
{    
    if( [key isEqualToString:@"percentage"] )
        return YES;
    
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx 
{
    CGPoint center = CGPointMake( self.bounds.size.width/2, self.bounds.size.height/2 );
    CGFloat radius = MIN( center.x, center.y ) - 1;

    CGFloat startingAngleRad = DEG2RAD( INITIAL_ANGLE );
    CGFloat endingAngleRad = DEG2RAD( ENDING_ANGLE );
    CGFloat currentAngle = INITIAL_ANGLE + ( INITIAL_ANGLE * self.percentage/100.0 );
    CGFloat currentAngleRad = DEG2RAD( currentAngle );
    
    CGPoint startingPoint = CGPointMake( center.x + radius * cosf(startingAngleRad), center.y + radius * sinf(startingAngleRad) );
    CGPoint endPoint = CGPointMake( center.x + radius * cosf(currentAngleRad) , center.y + radius * sinf(currentAngleRad) );
    
    // Arc
    CGContextBeginPath( ctx );
    CGContextMoveToPoint( ctx, center.x, center.y );    
    CGContextAddLineToPoint( ctx, startingPoint.x, startingPoint.y );
    CGContextAddArc( ctx, center.x, center.y, radius, startingAngleRad, currentAngleRad, NO );
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor( ctx, self.mainColor.CGColor );
    CGContextSetStrokeColorWithColor( ctx, self.mainColor.CGColor );
    CGContextSetLineWidth( ctx, 1 );
    
    CGContextDrawPath( ctx, kCGPathFillStroke );
    
    // Background
    CGContextBeginPath( ctx );
    CGContextMoveToPoint( ctx, center.x, center.y );    
    CGContextAddLineToPoint( ctx, endPoint.x, endPoint.y );
    CGContextAddArc( ctx, center.x, center.y, radius, currentAngleRad, endingAngleRad, NO );
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor( ctx, self.secondaryColor.CGColor );
    CGContextSetStrokeColorWithColor( ctx, self.secondaryColor.CGColor );
    CGContextSetLineWidth( ctx, 1 );
    
    CGContextDrawPath( ctx, kCGPathFillStroke );

    // Center & progress line
    CGContextBeginPath( ctx );    
    CGContextMoveToPoint( ctx, center.x, center.y );
    CGRect rect = CGRectMake( center.x - CENTER_WIDTH/2, center.y - CENTER_WIDTH/2, CENTER_WIDTH, CENTER_WIDTH );
    CGContextAddEllipseInRect( ctx, rect );
    CGContextMoveToPoint( ctx, center.x, center.y );
    CGContextAddLineToPoint( ctx, endPoint.x, endPoint.y );
    
    CGContextClosePath(ctx);
    
    CGContextSetFillColorWithColor( ctx, self.lineColor.CGColor );
    CGContextSetStrokeColorWithColor( ctx, self.lineColor.CGColor );
    CGContextSetLineCap( ctx, kCGLineCapButt );
    CGContextSetLineWidth( ctx, 5 );
    
    CGContextDrawPath( ctx, kCGPathFillStroke );
    
    
}

@end
