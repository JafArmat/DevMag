//
//  CustomPin.m
//  DevMag
//
//  Created by Alexandru Antonica on 2/27/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "CustomPin.h"

@implementation CustomPin


- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:placeName description:description {
    self = [super init];
    if (self != nil) {
        self.coordinate = location;
        self.title = placeName;
        self.subtitle = description;
    }
    return self;
}

@end
