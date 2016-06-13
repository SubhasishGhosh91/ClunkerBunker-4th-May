//
//  superViewController.m
//  ClunkerBunker
//
//  Created by Mindpace on 17/02/16.
//  Copyright (c) 2016 Mindpace. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController
{
    NSMutableArray *sharedConnectionList;
}
@synthesize request,completitionBlock,internalConnection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Web Service related Methods

-(NSMutableURLRequest *)prepareUrl:(NSMutableDictionary *)postDict suffixOfURL:(NSString *)suffixURL
{
    NSError *error = nil;
    NSData *jsonRequestDict = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *params = [[NSString alloc] initWithData:jsonRequestDict encoding:NSUTF8StringEncoding];
    //NSLog(@"***jsonCommand***%@",jsonCommand);
    
    NSString *jsonRequest = [[NSString alloc] initWithFormat:@"requestParam=%@", params];
    
    NSLog(@"jsonRequest is %@", jsonRequest);
    
    NSString *strUrl = [BASEURL stringByAppendingString:suffixURL];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *requestUrl = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [requestUrl setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [requestUrl setHTTPBody: requestData];
    
    return requestUrl;
}

-(id)initWithRequest:(NSMutableURLRequest *)req  //NSURLRequest
{
    self = [super init];
    if (self)
    {
        [self setRequest:req];
    }
    return self;
}

-(void)start
{
    
    container = [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    
    [sharedConnectionList addObject:self];
    
}

#pragma mark - NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if([self completitionBlock])
        [self completitionBlock](container,nil);
    
    [sharedConnectionList removeObject:self];
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
    if([self completitionBlock])
        [self completitionBlock](nil,error);
    
    [sharedConnectionList removeObject:self];
    
}

#pragma mark - Database

-(NSArray *)showAllValuesForEntity:(NSString *)entityName {
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequestForMyEvents = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSArray *allData = [[[appDel managedObjectContext] executeFetchRequest:fetchRequestForMyEvents error:nil] mutableCopy];

    return allData;
}

-(void)deleteAllValuesFromEntity:(NSString *)entityName {
    
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];

    for (NSManagedObject *managedObject in [self showAllValuesForEntity:entityName])
    {
        [[appDel managedObjectContext] deleteObject:managedObject];
    }
}



#pragma mark - Email & Phone Validation

-(BOOL)validEmail:(NSString*)emailString
{
    /*  NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
     NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
     NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
     NSLog(@"%i", regExMatches);
     if (regExMatches == 0) {
     return NO;
     } else
     return YES;*/
    
    //Quick return if @ Or . not in the string
    if([emailString rangeOfString:@"@"].location==NSNotFound || [emailString rangeOfString:@"."].location==NSNotFound)
        return NO;
    
    //Break email address into its components
    NSString *accountName=[emailString substringToIndex: [emailString rangeOfString:@"@"].location];
    emailString=[emailString substringFromIndex:[emailString rangeOfString:@"@"].location+1];
    
    //’.’ not present in substring
    if([emailString rangeOfString:@"."].location==NSNotFound)
        return NO;
    NSString *domainName=[emailString substringToIndex:[emailString rangeOfString:@"."].location];
    NSString *subDomain=[emailString substringFromIndex:[emailString rangeOfString:@"."].location+1];
    
    //username, domainname and subdomain name should not contain the following charters below
    //filter for user name
    NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;’:\"<>,?/`";
    //filter for domain
    NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;’:\"<>,+?/`";
    //filter for subdomain
    NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";’<>,?/1234567890";
    
    //subdomain should not be less that 2 and not greater 6
    if(!(subDomain.length>=2 && subDomain.length<=6)) return NO;
    
    if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
        return NO;
    
    return YES;
    
}

#pragma mark - Set UserDefaultValue

- (void)setUserDefaultValue:(id)value ForKey:(NSString *)key
{
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getUserDefaultValueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)RemoveUserDefaultValueForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

#pragma mark - Activity Indicator

+ (UIActivityIndicatorView *)startActivity:(UIView *)view
{
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = view.center;
    activityView.color = [UIColor whiteColor];
    [view addSubview:activityView];
    view.userInteractionEnabled = NO;
    [activityView startAnimating];
    
    return activityView;
}

+ (UIActivityIndicatorView *)stopActivity:(UIView *)view
{
    
    UIActivityIndicatorView *activityView = [self activityForView:view];
    activityView.center = view.center;
    [view addSubview:activityView];
    view.userInteractionEnabled = YES;
    [activityView stopAnimating];
    
    return activityView;
}

+ (UIActivityIndicatorView *)activityForView:(UIView *)view
{
    UIActivityIndicatorView *activity = nil;
    NSArray *subviews = view.subviews;
    Class activityClass = [UIActivityIndicatorView class];
    for (UIView *view in subviews)
    {
        if ([view isKindOfClass:activityClass])
        {
            activity = (UIActivityIndicatorView *)view;
        }
    }
    
    return activity;
}

#pragma mark -

- (UIImage *)screenshot:(UIView *)viewToBeCaptured {
    
    UIGraphicsBeginImageContextWithOptions(viewToBeCaptured.frame.size, NO, 1);
    [viewToBeCaptured drawViewHierarchyInRect:viewToBeCaptured.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIVisualEffectView *)blurView:(CGRect)viewRectbound
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = viewRectbound;
    
    return visualEffectView;
}

-(CGRect)getEventDetailsViewFrame:(CGFloat)screenHeight :(UIView *)eventDetailsView :(BOOL)isShown
{
    CGRect viewFrame;
    
    if (isShown == NO) {
        viewFrame = CGRectMake(eventDetailsView.frame.origin.x, screenHeight/568.0f *143.0f , eventDetailsView.frame.size.width, eventDetailsView.frame.size.height);
    }
    else {
        viewFrame = CGRectMake(eventDetailsView.frame.origin.x, screenHeight , eventDetailsView.frame.size.width, eventDetailsView.frame.size.height);
    }
    
    return viewFrame;
}

-(NSAttributedString *)firstLetterBigger:(NSString *)stringFromResponse forLabel:(UILabel *)lbl {
    
    stringFromResponse = [stringFromResponse uppercaseString];
    
    NSArray *wordsArr = [stringFromResponse componentsSeparatedByString:@" "];
    
    NSMutableAttributedString *finalAttSrt = [[NSMutableAttributedString alloc] init];
    
    for (NSString *word in wordsArr) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[word stringByAppendingString:@" "]];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:lbl.font.pointSize + 15.0f]
                                 range:NSMakeRange(0, 1)];
        
        [finalAttSrt appendAttributedString:attributedString];
    }
    //    CFStringTrimWhitespace((__bridge CFMutableStringRef) finalAttSrt);
    
    return finalAttSrt;
}


@end
