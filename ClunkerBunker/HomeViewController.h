//
//  HomeViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>

@interface HomeViewController : SuperViewController<MKMapViewDelegate,MKAnnotation,UISearchBarDelegate,CLLocationManagerDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIImageView *barsImgVw;
@property (strong, nonatomic) IBOutlet UIButton *showLeftPannelBtnOutlet;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *eventDetailsView;

@property (strong, nonatomic) IBOutlet UIImageView *eventImgView;

@property (strong, nonatomic) IBOutlet UIView *userCount;
@property (strong, nonatomic) IBOutlet UILabel *lblUserCount;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblTimerange;
@property (strong, nonatomic) IBOutlet UILabel *lblCost;
@property (strong, nonatomic) IBOutlet UILabel *lblAddress;
@property (strong, nonatomic) IBOutlet UITextView *txtVwEventDescription;
@property (strong, nonatomic) IBOutlet UIButton *fbPageBtn;
@property (strong, nonatomic) IBOutlet UIButton *websiteBtn;
@property (strong, nonatomic) IBOutlet UIButton *contactEmailBtn;

@property (weak, nonatomic) IBOutlet UIButton *showEventDetailsBtnOutlet;


- (IBAction)likeAction:(id)sender;
- (IBAction)favouriteAction:(id)sender;
- (IBAction)rsvpAction:(id)sender;
- (IBAction)shareAction:(id)sender;
- (IBAction)fbBtnAction:(id)sender;
- (IBAction)contactAction:(id)sender;
- (IBAction)websiteBtnAction:(id)sender;

- (IBAction)showEventDetailsAction:(id)sender;

@end
