//
//  MapLocationViewController.m
//  DevMag
//
//  Created by Alexandru Antonica on 2/27/16.
//  Copyright © 2016 Alexandru Antonica. All rights reserved.
//

#import "MapLocationViewController.h"
#import "CustomPin.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface MapLocationViewController (){
    NSArray *myLats;
    NSArray *myLongs;
    CLLocationManager *locationManager;
    
}
-(void)downloadImageForAnnotation:(MKAnnotationView*)view;
@end

@implementation MapLocationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    myLats  = @[@46.5204682,@46.3452602,@46.78195217,@47.29627767,@46.48688446, @46.33449402, @46.48689581, @46.95100676];
    myLongs = @[@25.91002975, @27.43715727, @26.61654275, @26.76404152, @25.83631388, @27.47759154, @27.57226694, @25.74756436];
    
    [self askForPermitions];
    
    [locationManager startUpdatingLocation];
    
    [self prepLocations];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) prepLocations{
    
    NSNumber *number = myLats[arc4random() % [myLats count]];
    CLLocationDegrees lat = [number doubleValue];
    
    number = myLongs[arc4random() % [myLongs count]];
    CLLocationDegrees lg = [number doubleValue];
    
    self.coordinates = CLLocationCoordinate2DMake(lat, lg);
}

#pragma MyMethods
-(void)askForPermitions{
    
    if (!locationManager) {
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 50;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
            [locationManager requestWhenInUseAuthorization];
        }
    }
}


#pragma CLLocationManagerDelegae methods
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
  
    self.mapView.centerCoordinate = self.coordinates;
    
    CustomPin *myPin = [[CustomPin alloc] initWithCoordinates:self.coordinates placeName:self.prod.nume description:self.prod.descriere];
    
    [self.mapView  addAnnotation:myPin];
    
}

-(void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error{
    [locationManager stopUpdatingLocation];
}


- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
                                          initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        
        pinView.canShowCallout = YES;
        pinView.animatesDrop = NO;
        [self downloadImageForAnnotation:pinView];
    }
    else {
        [mapView.userLocation setTitle:@"I am here"];
    }
    return pinView;
}
-(void)downloadImageForAnnotation:(MKAnnotationView*)view{
    
    //download the image
    NSURL *url = [[NSURL alloc]initWithString:self.prod.thumbnail];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    __weak UIImageView *imageViewWeak = imageView;
    [imageView setImageWithURLRequest:urlRequest
                     placeholderImage:nil
                              success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                  
                                  [imageViewWeak setImage:image];
                                  
                                  view.leftCalloutAccessoryView = imageViewWeak;
                                  //view.leftCalloutAccessoryView setNeedsDisplay];
                                  NSLog(@"Thumbnail downloaded");
                              } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                  NSLog(@"Thumbnail not downloaded");
                                  
                              }];
}
















@end
