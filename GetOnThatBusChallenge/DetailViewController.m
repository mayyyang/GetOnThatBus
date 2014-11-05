//
//  DetailViewController.m
//  GetOnThatBusChallenge
//
//  Created by May Yang on 11/4/14.
//  Copyright (c) 2014 May Yang. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *busStopName;
@property (weak, nonatomic) IBOutlet UILabel *routes;
@property (weak, nonatomic) IBOutlet UILabel *transfers;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.activityIndicator.hidesWhenStopped = YES;

    NSString *description = [self.busStopDictionary objectForKey:@"_address"];
//    [self.webView loadHTMLString:description baseURL:nil];
    NSURL *url = [NSURL URLWithString:description];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void) viewDidAppear:(BOOL)animated
{

    self.busStopName.backgroundColor = [UIColor yellowColor];
    self.busStopName.text = [self.busStopDictionary objectForKey:@"cta_stop_name"];

    self.routes.text = [self.busStopDictionary objectForKey:@"routes"];

    self.transfers.text = [self.busStopDictionary objectForKey:@"inter_modal"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicator stopAnimating];
}



@end
