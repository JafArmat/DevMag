//
//  MapLocationViewController.h
//  DevMag
//
//  Created by Alexandru Antonica on 2/27/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Produs.h"
@interface MapLocationViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate>

@property CLLocationCoordinate2D coordinates;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak) Produs *prod;

@end
