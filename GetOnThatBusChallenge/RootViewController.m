//
//  ViewController.m
//  GetOnThatBusChallenge
//
//  Created by May Yang on 11/4/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "TableViewController.h"
#import <MapKit/MapKit.h>

#define kURL @"https://s3.amazonaws.com/mobile-makers-lib/bus.json"

@interface RootViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKPointAnnotation *transitStop;
@property (strong, nonatomic) NSArray *pinStops;
@property (strong, nonatomic) NSMutableArray *annotationsArray;
@property NSInteger index;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.annotationsArray = [NSMutableArray array];

    NSURL *url = [NSURL URLWithString:kURL];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (connectionError) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message:connectionError.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Gosh Darnit" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okButton];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.pinStops = [dict objectForKey:@"row"];

            for (NSDictionary *d in self.pinStops)
            {
                NSDictionary *locationDictionary = d[@"location"];
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake([locationDictionary[@"latitude"] floatValue], [locationDictionary[@"longitude"] floatValue]);
                MKPointAnnotation *busStop = [[MKPointAnnotation alloc] init];
                busStop.coordinate = location;
                busStop.title = d[@"cta_stop_name"];
                busStop.subtitle = d[@"routes"];
                [self.mapView addAnnotation:busStop];
                [self.annotationsArray addObject:busStop];


                CLLocationCoordinate2D center = location;
                MKCoordinateSpan coordinateSpan;
                coordinateSpan.latitudeDelta = .2;
                coordinateSpan.longitudeDelta = .2;
                MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
                [self.mapView setRegion:region animated:YES];

            }

        }
        
    }];


}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.index = [self.annotationsArray indexOfObject:view.annotation];
    [self performSegueWithIdentifier:@"segue" sender:control];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
        pin.canShowCallout = YES;
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    self.index = [self.annotationsArray indexOfObject:annotation];
    NSDictionary *busStopDictionary = self.pinStops[self.index];
//    NSString *result = busStopDictionary[@"inter_modal"];
    NSString *value = [busStopDictionary objectForKey:@"inter_modal"];

    if ([value  isEqual: @"Metra"])
    {
        pin.pinColor = MKPinAnnotationColorGreen;
    }

    if ([value isEqual:@"Pace"])
    {
        pin.pinColor = MKPinAnnotationColorPurple;
    }
//    if (result)
//    {
////        pin.backgroundColor = [UIColor blueColor];
//        pin.pinColor = MKPinAnnotationColorGreen;
//    }

    return pin;
}

- (IBAction)segmentControlAction:(UISegmentedControl *)sender
{
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            [self performSegueWithIdentifier:@"segueToTableView" sender:sender];
            //            self.mapView.mapType = MKMapTypeHybrid;
            break;

        default:
            break;
    }

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segue"])
    {
        DetailViewController *detailVC = segue.destinationViewController;
        NSDictionary *busStopDictionary = self.pinStops[self.index];
        detailVC.busStopDictionary = busStopDictionary;
    }


    else
    {
        TableViewController *tableVC = segue.destinationViewController;
        NSMutableArray *array = self.pinStops[self.index];
        tableVC = array;
//        NSDictionary *busStopDictionary = self.pinStops[self.index];
//        tableVC.busStopDictionary = busStopDictionary;
    }

}


//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//
//    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
//    pin.canShowCallout = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//
//    return pin;
//}


@end
