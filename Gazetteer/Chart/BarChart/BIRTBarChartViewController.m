//
//  BIRTBarChartViewController.m
//  Gazetteer
//
//  Created by Maitrik Patel on 7/18/14.
//  Copyright (c) 2014 PNB. All rights reserved.
//

#import "BIRTBarChartViewController.h"

@interface BIRTBarChartViewController ()

@property BOOL logout;
@property (strong, nonatomic) NSArray *bookMarks;

@end

@implementation BIRTBarChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewDidLoad {
    self.refreshView = TRUE;
    self.BarChartWebView.scrollView.scrollEnabled = NO;
    self.BarChartWebView.scrollView.bounces = NO;
    CGFloat borderWidth = 1.0f;
    self.view.layer.borderWidth = borderWidth;
    [self.view setFrame:CGRectInset(self.view.frame, -borderWidth, -borderWidth)];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.BarChartWebView.delegate = self;
    self.logout = FALSE;
    if (self.refreshView) {
        [self reloadData];
        self.refreshView = FALSE;
    }
    
}

-(void) reloadData
{
    if (self.chartData != nil) {
        //NSLog(@"URL is loading");
       [self loadHTML:@"jsapi.html"];
    }
}



-(void) webViewDidFinishLoad:(UIWebView *)webView {
   [self loadViewFromJS:webView];
}

-(void) loadViewFromJS : (UIWebView *) webView {
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@",REPORT_FOLDER, @"GDP per Capita.rptdesign"];
    
    if (self.bookMarks == nil || [self.bookMarks count] == 0) {
        self.bookMarks = [self getBookMarks:fileName];
    }
    
    if (self.bookMarks != nil) {
        NSString *bookMark ;
        
        for (NSDictionary *data in self.bookMarks) {
            NSString *val = [data valueForKey:@"BookMarkValue"];
            if (self.chartData.country == nil && self.chartData.continent == nil && self.chartData.region == nil && [[val lowercaseString] hasPrefix:@"world"]) {
                bookMark = val;
                break;
            } else if (self.chartData.country != nil  && [[val lowercaseString] hasPrefix:@"country"]) {
                bookMark = val;
                break;
            } else if (self.chartData.continent != nil  && [[val lowercaseString] hasPrefix:@"continent"]) {
                bookMark = val;
                break;
            } else if (self.chartData.region != nil  && [[val lowercaseString] hasPrefix:@"region"]) {
                bookMark = val;
                break;
            }
            
        }
        
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithDictionary:self.chartData.userData];
        
        [data removeObjectForKey:@"Childs"];
        NSString *name = [self.chartData.userData valueForKey:@"name"];
        
        NSString *level = [data valueForKey:@"level"];
        [data removeObjectForKey:@"level"];
        [data removeObjectForKey:@"name"];
        NSMutableDictionary *jsData = [[NSMutableDictionary alloc] initWithDictionary:data];
        jsData[@"iportalUrl"] =  [NSString stringWithFormat:@"%@%@", IHUB_SERVER_URL , @"iportal/"];
        
        if ([level intValue] == 3) {
            [jsData setObject:name forKey:@"country"];
            self.view.layer.borderColor = [UIColor colorWithRed:42/255.0f green:186/255.0f blue:43/255.0f alpha:1.0f].CGColor;
        } else if ([level intValue] == 2) {
            [jsData setObject:name forKey:@"region"];
            self.view.layer.borderColor = [UIColor colorWithRed:102/255.0f green:170/255.0f blue:249/255.0f alpha:1.0f].CGColor;
        } else if ([level intValue] == 1){
            [jsData setObject:name forKey:@"continent"];
            self.view.layer.borderColor = [UIColor colorWithRed:255/255.0f green:159/255.0f blue:42/255.0f alpha:1.0f].CGColor;
        } else {
            self.view.layer.borderColor = [UIColor blackColor].CGColor;
        }
        
        jsData[@"report"] = fileName;
        jsData[@"bookmark"] = bookMark;
        jsData[@"width"] = @"390";
        jsData[@"height"] = @"450";
        
        NSError *jsonError;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsData options:0 error:&jsonError];
        
        if (jsonError != nil)
        {
            //call error callback function here
            //NSLog(@"Error creating JSON from the response  : %@",[jsonError localizedDescription]);
            return;
        }
        
        NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@(%@);",@"init",jsonStr] ];
    } else {
        [webView setDelegate:self];
        [self  loadBlankView:webView];
    }
    
    
    
}

-(NSArray *) getBookMarks : (NSString *) fileName {
    
    //NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"files?search=%@&authId=%@"],[fileName stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding], self.chartData.authId];
    NSString *getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"files/search?name=%@"],[fileName stringByAddingPercentEscapesUsingEncoding :NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                                cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                            timeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:self.chartData.authId forHTTPHeaderField:@"authToken"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [urlRequest setValue:@"gazetteer/0.0.1" forHTTPHeaderField:@"User-Agent"];
    
    NSError *error;
    NSError *urlConnectionError;	
    NSURLResponse *urlResponse;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&urlConnectionError];

    if (urlConnectionError != nil ) {
        if ([urlConnectionError code] == -1009) {
            self.logout = TRUE;
        }

        [self showAlert:[urlConnectionError localizedDescription]];
        @throw [NSException exceptionWithName:@"ERROR" reason:[urlConnectionError localizedDescription] userInfo:nil];
    }
    
    NSDictionary* response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (error != nil ) {
        self.logout = FALSE;
        [self showAlert:[error localizedDescription]];
        return nil;
    }
    
    NSArray * responseArr = response[@"itemList"][@"file"];
    
    if (responseArr == nil) {
        self.logout = FALSE;
        [self showAlert:@"Unable to Find the File."];
        return nil;
    }
    
    NSDictionary * dict = [responseArr objectAtIndex:0];
    
    NSString *fileId = [dict valueForKey:@"id"];
    NSLog(@"FILE ID: %@",fileId);
    
    //getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"visuals/%@/bookmarks?authId=%@"],fileId, self.chartData.authId];
    getUrl =[NSString stringWithFormat:[NSString stringWithFormat:@"%@%@",REST_API_URL, @"visuals/%@/bookmarks"],fileId];
    
    urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:getUrl]
                                         cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                     timeoutInterval:60];
    [urlRequest setHTTPMethod:@"GET"];
    [urlRequest setValue:self.chartData.authId forHTTPHeaderField:@"authToken"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [urlRequest setValue:@"gazetteer/0.0.1" forHTTPHeaderField:@"User-Agent"];
    
    
    data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&urlConnectionError];
    
    
    if (urlConnectionError != nil ) {
        if ([urlConnectionError code] == -1009) {
            self.logout = TRUE;
        }

        [self showAlert:[urlConnectionError localizedDescription]];
        @throw [NSException exceptionWithName:@"ERROR" reason:[urlConnectionError localizedDescription] userInfo:nil];
    }
    
    response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil ) {
        self.logout = FALSE;
        [self showAlert:[error localizedDescription]];
        return nil;
    }

    //return response[@"BookmarkList"][@"BookMark"];
    return response[@"BookMarks"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.logout) {
        [self performSegueWithIdentifier:@"logout" sender:self];
        self.logout = FALSE;
    }
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.view setUserInteractionEnabled:YES];}

-(void) showAlert : (NSString *)error {
    [self.view setUserInteractionEnabled:NO];
    //NSLog(@"errro desc %@", error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:error delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"Load Failed ERROR CODE %li", (long)[error code]);
    if([error code] == NSURLErrorCancelled) {
        return;
    }
    [self loadBlankView:webView];
    if (error != nil) {
        if ([error code] == -1009) {
            self.logout = TRUE;
        }
        [self showAlert:[error localizedDescription]];
    }
    
}


-(void)  loadBlankView:(UIWebView *)webView  {
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void) loadHTML:(NSString*) pageName
{
	NSRange range = [pageName rangeOfString:@"."];
    if (range.length > 0)
    {
		
    	NSString *fileExt = [pageName substringFromIndex:range.location+1];
        NSString *fileName = [pageName substringToIndex:range.location];
        
        
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:fileExt inDirectory:@""]];
        
		if (url != nil)
		{
            NSError *error;
            NSString *pageContent = [NSString stringWithContentsOfURL:url
                                                             encoding:NSASCIIStringEncoding
                                                                error:&error];
            
            NSString *finalContent = [pageContent stringByReplacingOccurrencesOfString:@"jsapiUrl" withString:[NSString stringWithFormat:@"%@%@", IHUB_SERVER_URL, @"iportal/jsapi"]];
            
            finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{uName}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.userName, "'"]];
            if (self.chartData.password == nil) {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:self.chartData.password];
            } else {
                finalContent = [finalContent stringByReplacingOccurrencesOfString:@"{pwd}" withString:[NSString stringWithFormat:@"%s%@%s", "'", self.chartData.password, "'"]];
            }
            
       		[self.BarChartWebView loadHTMLString:finalContent baseURL:url];
            
        }
    }
}

// This function is called on all location change :
- (BOOL)webView:(UIWebView *)webView2 shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    // Intercept custom location change, URL begins with "js-call:"
    if ([[[request URL] absoluteString] hasPrefix:@"js-call:"]) {
        
        // Extract the selector name from the URL
        NSArray *components = [[[request URL] absoluteString] componentsSeparatedByString:@":"];
        NSString *function = [components objectAtIndex:1];
        
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(function)];
        #pragma clang diagnostic pop
        
        return NO;
    }
    
    return YES;
    
}

- (void)timeOut {
    
    NSLog(@"I am being called");
    [self performSegueWithIdentifier:@"goBack" sender:self];
}
@end
