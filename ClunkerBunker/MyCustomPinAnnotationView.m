//
//  MyCustomPinAnnotationView.m
//  ClunkerBunker
//
//  Created by Mindpace on 01/04/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "MyCustomPinAnnotationView.h"

@implementation MyCustomPinAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
{
    // The re-use identifier is always nil because these custom pins may be visually different from one another
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    
    // Fetch all necessary data from the point object
    MyCustomPointAnnotation* myCustomPointAnnotation = (MyCustomPointAnnotation*) annotation;
    //self.price = myCustomPointAnnotation.price;
    self.eventType = myCustomPointAnnotation.eventType;
    
    self.eventID = myCustomPointAnnotation.eventID;
    self.eventName = myCustomPointAnnotation.eventName;
    self.eventDate = myCustomPointAnnotation.eventDate;
    self.eventStartTime = myCustomPointAnnotation.eventStartTime;
    self.eventEndTime = myCustomPointAnnotation.eventEndTime;
    self.eventAddress = myCustomPointAnnotation.eventAddress;
    self.eventCost = myCustomPointAnnotation.eventCost;
    self.eventDetails = myCustomPointAnnotation.eventDetails;

    self.eventTag1 = myCustomPointAnnotation.eventTag1;
    self.eventTag2 = myCustomPointAnnotation.eventTag2;
    self.eventTag3 = myCustomPointAnnotation.eventTag3;

    
    // Callout settings - if you want a callout bubble
    //self.canShowCallout = YES;
    //self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    //set pin image according to event type
    if ([self.eventType isEqualToString:@"event"]) {
        
        self.image = [UIImage imageNamed:@"event_pin.png"];
    }
    else if ([self.eventType isEqualToString:@"show"]) {
        
        self.image = [UIImage imageNamed:@"show_pin.png"];
    }
    else {
        
        self.image = [UIImage imageNamed:@"meet_pin.png"];
    }
        
    /*UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, 30, 25)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"$%d", self.price];
    label.font = [label.font fontWithSize:9];
    [self addSubview:label];*/
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView* hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
    
}

//https://gist.github.com/ShadoFlameX/7495098

@end
