//
//  superViewController.h
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection * internalConnection;
    NSMutableData * container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic,copy)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSMutableURLRequest *request; //NSURLRequest
@property (nonatomic,copy)void (^completitionBlock) (id obj, NSError * err);

-(NSMutableURLRequest *)prepareUrl:(NSMutableDictionary *)postDict suffixOfURL:(NSString *)suffixURL;

-(void)start;

-(NSArray *)showAllValuesForEntity:(NSString *)entityName;
-(void)deleteAllValuesFromEntity:(NSString *)entityName;

-(BOOL)validEmail:(NSString*)emailString;

- (void)setUserDefaultValue:(id)value ForKey:(NSString *)key;
- (id)getUserDefaultValueForKey:(NSString *)key;
- (void)RemoveUserDefaultValueForKey:(NSString *)key;

+ (UIActivityIndicatorView *)startActivity:(UIView *)view;
+ (UIActivityIndicatorView *)stopActivity:(UIView *)view;

- (UIImage *)screenshot:(UIView *)viewToBeCaptured;

-(UIVisualEffectView *)blurView:(CGRect)viewRectbound;

-(CGRect)getEventDetailsViewFrame:(CGFloat)screenHeight :(UIView *)eventDetailsView :(BOOL)isShown;

-(NSAttributedString *)firstLetterBigger:(NSString *)stringFromResponse forLabel:(UILabel *)lbl;

@end
