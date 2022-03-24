#import "FlutterSiriSuggestionsPlugin.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import <Intents/Intents.h>
@import CoreSpotlight;
@import MobileCoreServices;


@implementation FlutterSiriSuggestionsPlugin {
    FlutterMethodChannel *_channel;
}

NSString *kPluginName = @"flutter_siri_suggestions";
NSString *kFn_becomeCurrent = @"becomeCurrent";
NSString *kFn_deleteAllSavedUserActivities = @"deleteAllSavedUserActivities";
NSString *kFn_deleteSavedUserActivitiesWithPersistentIdentifier = @"deleteSavedUserActivitiesWithPersistentIdentifier";
NSString *kFn_deleteSavedUserActivitiesWithPersistentIdentifiers = @"deleteSavedUserActivitiesWithPersistentIdentifiers";


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:kPluginName
                                     binaryMessenger:[registrar messenger]];
    FlutterSiriSuggestionsPlugin* instance = [[FlutterSiriSuggestionsPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if([kFn_becomeCurrent isEqualToString:call.method]) {
        return [self becomeCurrent:call result:result];
    }

    if([kFn_deleteAllSavedUserActivities isEqualToString:call.method]) {
        return [self deleteAllSavedUserActivities:call result:result];
    }
    
    if([kFn_deleteSavedUserActivitiesWithPersistentIdentifier isEqualToString:call.method]) {
        return [self deleteSavedUserActivitiesWithPersistentIdentifier:call result:result];
    }

    if([kFn_deleteSavedUserActivitiesWithPersistentIdentifiers isEqualToString:call.method]) {
        return [self deleteSavedUserActivitiesWithPersistentIdentifiers:call result:result];
    }
    
    result(FlutterMethodNotImplemented);
    
}

- (void)deleteAllSavedUserActivities:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (@available(iOS 12.0, *)) {
        [NSUserActivity deleteAllSavedUserActivitiesWithCompletionHandler:^{
            result(nil);
        }];
    } else {
        result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"deleteAllSavedUserActivities not available." details:nil]);
    }
}

- (void)deleteSavedUserActivitiesWithPersistentIdentifier:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *persistentIdentifier = call.arguments;
    
    [self _deleteSavedUserActivitiesWithPersistentIdentifiers:@[persistentIdentifier] completionHandler:^{
        result(nil);
    } failedHandler:^{
        result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"deleteSavedUserActivitiesWithPersistentIdentifiers not available." details:nil]);
    }];
}

- (void)deleteSavedUserActivitiesWithPersistentIdentifiers:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSArray *persistentIdentifiers = call.arguments;
    
    [self _deleteSavedUserActivitiesWithPersistentIdentifiers:persistentIdentifiers completionHandler:^{
        result(nil);
    } failedHandler:^{
        result([FlutterError errorWithCode:@"UNAVAILABLE" message:@"deleteSavedUserActivitiesWithPersistentIdentifiers not available." details:nil]);
    }];
}


- (void)becomeCurrent:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSDictionary *arguments = call.arguments;
    
    NSAssert( ([arguments objectForKey:@"key"] != nil), @"key must not nil!");
    
    NSString *title = [arguments objectForKey:@"title"];
    NSString *key = [arguments objectForKey:@"key"];
    
    NSDictionary *userInfo = [arguments objectForKey:@"userInfo"];    
    NSNumber *isEligibleForSearch = [arguments objectForKey:@"isEligibleForSearch"];
    NSNumber *isEligibleForPrediction = [arguments objectForKey:@"isEligibleForPrediction"];
    NSString *contentDescription = [arguments objectForKey:@"contentDescription"];
    NSString *suggestedInvocationPhrase = [arguments objectForKey:@"suggestedInvocationPhrase"];
    NSString *persistentIdentifier = [arguments objectForKey:@"persistentIdentifier"];

    if(persistentIdentifier == (NSString *)[NSNull null]) persistentIdentifier = key;
        
    
    
    if (@available(iOS 9.0, *)) {
        
        NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:[NSString stringWithFormat:@"%@-%@", kPluginName, key]];
        
        [activity setEligibleForSearch:[isEligibleForSearch boolValue]];

        if (@available(iOS 12.0, *)) {
            [activity setEligibleForPrediction:[isEligibleForPrediction boolValue]];
        }
        
        CSSearchableItemAttributeSet *attributes = [[CSSearchableItemAttributeSet alloc] initWithItemContentType: (NSString *)kUTTypeItem];
        
        
        activity.title = title;
        
        if(userInfo != (NSDictionary *)[NSNull null]) {
            activity.userInfo = userInfo;
        }
        
        attributes.contentDescription = contentDescription;
        
        
        if (@available(iOS 12.0, *)) {

            activity.persistentIdentifier = persistentIdentifier;
            
            // SIMULATOR HAS NOT RESPOND SELECTOR
            #if !(TARGET_IPHONE_SIMULATOR)
            activity.suggestedInvocationPhrase = suggestedInvocationPhrase;
            #endif
            
        }
        activity.contentAttributeSet = attributes;
        NSLog(@"userInfo :%@", userInfo);

        [[self rootViewController] setUserActivity:activity];
                
        [activity becomeCurrent];
        
        result(@{@"key": key,
                 @"persistentIdentifier": persistentIdentifier});
        return;

    }
    result(nil);
    
}

- (void)onAwake:(NSUserActivity*) userActivity method:(NSString *) method {
    if (@available(iOS 9.0, *)) {
        [userActivity resignCurrent];
        [userActivity invalidate];
    }
    
    NSMutableDictionary *dict = [@{ @"title": userActivity.title, @"key" : [userActivity.activityType stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@-", kPluginName] withString:@""] } mutableCopy];    
      
    if(userActivity.userInfo) [dict setObject:userActivity.userInfo forKey:@"userInfo"];
        
    
    if (@available(iOS 12.0, *)) {
        if(userActivity.persistentIdentifier) [dict setObject:userActivity.persistentIdentifier forKey:@"persistentIdentifier"];
    }
    
    [_channel invokeMethod:method arguments:dict];
    
}

#pragma mark -

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel {
    self = [super init];
    if(self) {
        _channel = channel;
    }
    return self;
}

- (UIViewController*)rootViewController {
    return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

#pragma mark - Application


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    return true;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *UIUserActivityRestoring))restorationHandler {

    if ([[userActivity activityType] hasPrefix:kPluginName]) {
        [self onAwake:userActivity method: @"onLaunch"];
        return true;
    } else 
      [self onAwake:userActivity method: @"failedToLaunchWithActivity"];
    return false;
    
    
}

#pragma mark - internal methods

- (void) _deleteSavedUserActivitiesWithPersistentIdentifiers:(NSArray*)persistentIdentifiers completionHandler:(void(^)(void))successHandler failedHandler:(void(^)(void))failedHandler {
    
    if (@available(iOS 12.0, *)) {
        [NSUserActivity deleteSavedUserActivitiesWithPersistentIdentifiers:persistentIdentifiers completionHandler:successHandler];
    } else {
        failedHandler();
    }
    
}

@end
