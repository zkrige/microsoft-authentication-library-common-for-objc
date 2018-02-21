// Copyright (c) Microsoft Corporation.
// All rights reserved.
//
// This code is licensed under the MIT License.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files(the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions :
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "MSIDRefreshableToken.h"

@class MSIDAccount;
@class MSIDToken;
@class MSIDToken;
@class MSIDToken;
@class MSIDRequestParameters;
@class MSIDToken;
@class MSIDToken;

@protocol MSIDSharedCacheAccessor <NSObject>

- (BOOL)saveAccessToken:(MSIDToken *)token
                account:(MSIDAccount *)account
          requestParams:(MSIDRequestParameters *)parameters
                context:(id<MSIDRequestContext>)context
                  error:(NSError **)error;

- (MSIDToken *)getATForAccount:(MSIDAccount *)account
                       requestParams:(MSIDRequestParameters *)parameters
                             context:(id<MSIDRequestContext>)context
                               error:(NSError **)error;

- (BOOL)saveSharedRTForAccount:(MSIDAccount *)account
                  refreshToken:(MSIDToken *)refreshToken
                       context:(id<MSIDRequestContext>)context
                         error:(NSError **)error;


- (MSIDToken *)getSharedRTForAccount:(MSIDAccount *)account
                              requestParams:(MSIDRequestParameters *)parameters
                                    context:(id<MSIDRequestContext>)context
                                      error:(NSError **)error;

- (MSIDToken *)getLatestRTForToken:(MSIDToken *)token
                           account:(MSIDAccount *)account
                           context:(id<MSIDRequestContext>)context
                             error:(NSError **)error;

- (NSArray<MSIDToken *> *)getAllSharedRTsWithClientId:(NSString *)clientId
                                                     context:(id<MSIDRequestContext>)context
                                                       error:(NSError **)error;

- (BOOL)removeSharedRTForAccount:(MSIDAccount *)account
                           token:(MSIDToken *)token
                         context:(id<MSIDRequestContext>)context
                           error:(NSError **)error;

@optional

- (MSIDToken *)getADFSTokenWithRequestParams:(MSIDRequestParameters *)parameters
                                         context:(id<MSIDRequestContext>)context
                                           error:(NSError **)error;

- (BOOL)saveIDToken:(MSIDToken *)token
            account:(MSIDAccount *)account
      requestParams:(MSIDRequestParameters *)parameters
            context:(id<MSIDRequestContext>)context
              error:(NSError **)error;

- (BOOL)saveAccount:(MSIDAccount *)account
      requestParams:(MSIDRequestParameters *)parameters
            context:(id<MSIDRequestContext>)context
              error:(NSError **)error;

- (BOOL)saveADFSToken:(MSIDToken *)token
              account:(MSIDAccount *)account
        requestParams:(MSIDRequestParameters *)parameters
              context:(id<MSIDRequestContext>)context
                error:(NSError **)error;

@end
