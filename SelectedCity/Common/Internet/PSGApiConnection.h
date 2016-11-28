//
//  PSGApiConnection.h
//  SelectedCity
//
//  Created by Pavel Samsonov on 26.11.16.
//  Copyright © 2016 Pavel Samsonov. All rights reserved.
//

@interface PSGApiConnection : NSObject

+ (PSGApiConnection * _Nullable)sharedApiConnection;

#pragma mark - Проверка связи с сетью
- (BOOL)connectedToInternet; // проверяет подключение к сети

//Получение данных с сервера
- (void)getDataWithSuccefullHandler:(void(^_Nonnull)(id _Nonnull data))successHandler
                    connectionError:(void(^_Nonnull)(NSError *_Nonnull error))connectionErrorHandler;

@end
