//
//  PSGApiConnection.m
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

#define COMPLETION_HANDLER void (^completionHandler)(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error)

@interface PSGApiConnection ()

@property (nonatomic) NSTimeInterval timeoutInterval;
@property (strong, nonatomic) NSString *getMethodTitle;
@property (strong, nonatomic, readwrite) NSString *serverPath;

@end

@implementation PSGApiConnection

#pragma mark - INIT

+ (PSGApiConnection *)sharedApiConnection
{
    static PSGApiConnection *connection;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connection = [[PSGApiConnection alloc] init];
    });
    return connection;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.timeoutInterval   = 25.0;
        self.getMethodTitle    = @"GET";
        self.serverPath = @"https://atw-backend.azurewebsites.net/api/countries";
    }
    return self;
}

#pragma mark - Проверка связи с сетью

- (BOOL) connectedToInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return (networkStatus == NotReachable) ? NO : YES;
}

#pragma mark - ACCESSORS

- (NSURLSessionConfiguration *)createSessionConfigDefault
{
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 15;
    sessionConfig.timeoutIntervalForResource = 30;
    
    return sessionConfig;
}

//Общий для GET-методов
- (void)standartGETWithURLString:(NSString *)urlString
                succefullHandler:(void(^)(id data))successHandler
                 connectionError:(void(^)(NSError *error))connectionErrorHandler
{
    NSURLSessionConfiguration *sessionConfig = [self createSessionConfigDefault];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlGetRequest = [NSMutableURLRequest requestWithURL:url
                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                             timeoutInterval:self.timeoutInterval];
    urlGetRequest.HTTPMethod = self.getMethodTitle;
    
    COMPLETION_HANDLER = ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error != nil)
        {
            NSLog(@"Ошибка подключения");
            dispatch_async(dispatch_get_main_queue(), ^{
                if(connectionErrorHandler != nil) connectionErrorHandler(error);
            });
            return;
        }

        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        
        switch (statusCode)
        {
            case 200:
            case 201:
            {
                NSError *parceError = nil;
                id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments
                                                                error:&parceError];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (successHandler != nil)
                        successHandler(jsonData);
                });
                return;
            }
                break;
                
            default:
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(connectionErrorHandler != nil) connectionErrorHandler(error);
                });
                break;
        }
    };
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:urlGetRequest completionHandler:completionHandler];
    [sessionDataTask resume];
}

//Получение данных с сервера
- (void)getDataWithSuccefullHandler:(void(^)(id serverData))successHandler
                    connectionError:(void(^)(NSError *error))connectionErrorHandler
{
    [self standartGETWithURLString:self.serverPath succefullHandler:successHandler connectionError:connectionErrorHandler];
}

@end













