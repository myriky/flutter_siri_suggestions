#import "FlutterSiriSuggestionsPlugin.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <Intents/Intents.h>
@import CoreSpotlight;
@import MobileCoreServices;


@implementation FlutterSiriSuggestionsPlugin {
    FlutterMethodChannel *_channel;
    NSMutableSet *_keySet;
}

NSString *kPluginName = @"flutter_siri_suggestions";

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
        return [self becomeCurrent:call result:result];
    }
    
    result(FlutterMethodNotImplemented);
    
}


- (void)becomeCurrent:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSDictionary *arguments = call.arguments;
    
    NSAssert( ([arguments objectForKey:@"key"] != nil), @"key must not nil!");
    
    NSString *title = [arguments objectForKey:@"title"];
    NSString *key = [arguments objectForKey:@"key"];
    
    NSNumber *isEligibleForSearch = [arguments objectForKey:@"isEligibleForSearch"];
    NSNumber *isEligibleForPrediction = [arguments objectForKey:@"isEligibleForPrediction"];
    NSString *contentDescription = [arguments objectForKey:@"contentDescription"];
    NSString *suggestedInvocationPhrase = [arguments objectForKey:@"suggestedInvocationPhrase"];
    
    if (@available(iOS 9.0, *)) {
        
        NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:[NSString stringWithFormat:@"%@-%@", kPluginName, key]];
        
        [activity setEligibleForSearch:[isEligibleForSearch boolValue]];

        if (@available(iOS 12.0, *)) {
            [activity setEligibleForPrediction:[isEligibleForPrediction boolValue]];
        }
        
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType: (NSString *)kUTTypeItem];
        
        
        activity.title = title;
        attributes.contentDescription = contentDescription;
        
        if (@available(iOS 12.0, *)) {
            
            // SIMULATOR HAS NOT RESPOND SELECTOR
            #if !(TARGET_IPHONE_SIMULATOR)
            activity.suggestedInvocationPhrase = suggestedInvocationPhrase;
            #endif
            
        }
        activity.contentAttributeSet = attributes;

        
        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        [rootViewController setUserActivity:activity];
        
        [_keySet addObject:activity.activityType];
        
        [activity becomeCurrent];
    }
    
    result(nil);
}

- (void)onAwake:(NSUserActivity*) userActivity {
    if (@available(iOS 9.0, *)) {
        [userActivity resignCurrent];
        [userActivity invalidate];
    }
    [_channel invokeMethod:@"onLaunch" arguments:@{@"title": userActivity.title, @"key" : [userActivity.activityType stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-", kPluginName] withString:@""], @"userInfo" : userActivity.userInfo}];
}

#pragma mark -

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel {
    self = [super init];
    if(self) {
        _channel = channel;
        _keySet = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Application


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    return true;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    if([_keySet containsObject:[userActivity activityType]]) {
        [self onAwake:userActivity];
        return true;
    }
    return false;
    
    
}



@end
