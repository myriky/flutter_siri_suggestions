#import "FlutterSiriSuggestionsPlugin.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <Intents/Intents.h>
@import CoreSpotlight;
@import MobileCoreServices;


@implementation FlutterSiriSuggestionsPlugin {
    FlutterMethodChannel *_channel;
    
}


NSString *kPluginName = @"flutter_siri_shortcuts";

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:kPluginName
                                     binaryMessenger:[registrar messenger]];
    FlutterSiriSuggestionsPlugin* instance = [[FlutterSiriSuggestionsPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"becomeCurrent" isEqualToString:call.method]) {
        [self becomeCurrent:call result:result];
    }
    
    result(FlutterMethodNotImplemented);
    
}


- (void)becomeCurrent:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"becomeCurrent");
    
    NSDictionary *arguments = call.arguments;
    
    
    NSString *title = [arguments objectForKey:@"title"];
    NSNumber *isEligibleForSearch = [arguments objectForKey:@"isEligibleForSearch"];
    NSNumber *isEligibleForPrediction = [arguments objectForKey:@"isEligibleForPrediction"];
    NSString *contentDescription = [arguments objectForKey:@"contentDescription"];
    NSString *suggestedInvocationPhrase = [arguments objectForKey:@"suggestedInvocationPhrase"];
    
    
    if (@available(iOS 9.0, *)) {
        
        NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:kPluginName];
        
        [activity setEligibleForSearch:[isEligibleForSearch boolValue]];
        
        if (@available(iOS 12.0, *)) {
            [activity setEligibleForPrediction:[isEligibleForPrediction boolValue]];
        }
        
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType: (NSString *)kUTTypeItem];
        
        
        activity.title = title;
        attributes.contentDescription = contentDescription;
        //attributes.thumbnailData = UIImage(named: "thumbnail.png")?.jpegData(compressionQuality: 1.0)
        
        if (@available(iOS 12.0, *)) {
            activity.suggestedInvocationPhrase = suggestedInvocationPhrase;
        }
        activity.contentAttributeSet = attributes;
        
        UIViewController* viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        
        viewController.userActivity = activity;
        
        
        [activity becomeCurrent];
    }
    
    result(nil);
}

- (void)onAwake:(NSUserActivity*) userActivity {
    if (@available(iOS 9.0, *)) {
        [userActivity resignCurrent];
        [userActivity invalidate];
    }
    [_channel invokeMethod:@"onLaunch" arguments:[userActivity userInfo]];
}

#pragma mark -

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel {
    self = [super init];
    if(self) {
        _channel = channel;
    }
    return self;
}

#pragma mark - Application


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    NSLog(@"willContinueUserActivityWithType");
    return true;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    NSLog(@"continueUserActivity");
    if ([[userActivity activityType] isEqualToString:kPluginName]) {
        [self onAwake:userActivity];
        return true;
    }
    return false;
    
    
}



@end
